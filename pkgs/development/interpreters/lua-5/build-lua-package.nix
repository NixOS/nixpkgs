# Generic builder for lua packages
{ lib
, lua
, wrapLua
# Whether the derivation provides a lua module or not.
, toLuaModule
}:

{
name ? "${attrs.pname}-${attrs.version}"

, version

# by default prefix `name` e.g. "lua5.2-${name}"
, namePrefix ? if lua.pkgs.isLuaJIT
               then lua.name + "-"
               else "lua" + lua.luaversion + "-"

# Dependencies for building the package
, buildInputs ? []

# Dependencies needed for running the checkPhase.
# These are added to buildInputs when doCheck = true.
, checkInputs ? []

# propagate build dependencies so in case we have A -> B -> C,
# C can import package A propagated by B
, propagatedBuildInputs ? []
, propagatedNativeBuildInputs ? []

# used to disable derivation, useful for specific lua versions
# TODO move from this setting meta.broken to a 'disabled' attribute on the
# package, then use that to skip/include in each lua${ver}Packages set?
, disabled ? false

# Additional arguments to pass to the makeWrapper function, which wraps
# generated binaries.
, makeWrapperArgs ? []

# Skip wrapping of lua programs altogether
, dontWrapLuaPrograms ? false

, meta ? {}

, passthru ? {}
, doCheck ? false

# Non-Lua / system (e.g. C library) dependencies. Is a list of deps, where
# each dep is either a derivation, or an attribute set like
# { name = "rockspec external_dependencies key"; dep = derivation; }
# The latter is used to work-around luarocks having a problem with
# multiple-output derivations as external deps:
# https://github.com/luarocks/luarocks/issues/766<Paste>
, externalDeps ? lib.unique (lib.filter (drv: !drv ? luaModule) (propagatedBuildInputs ++ buildInputs))

# Appended to the generated luarocks config
, extraConfig ? ""
# Inserted into the generated luarocks config in the "variables" table
, extraVariables ? ""
# The two above arguments have access to builder variables -- e.g. to $out

# relative to srcRoot, path to the rockspec to use when using rocks
, rockspecFilename ?  "../*.rockspec"

# must be set for packages that don't have a rock
, knownRockspec ? null

, ... } @ attrs:


# Keep extra attributes from `attrs`, e.g., `patchPhase', etc.

let
  # TODO fix warnings "Couldn't load rockspec for ..." during manifest
  # construction -- from initial investigation, appears it will require
  # upstream luarocks changes to fix cleanly (during manifest construction,
  # luarocks only looks for rockspecs in the default/system tree instead of all
  # configured trees)
  luarocks_config = "luarocks-config.lua";
  luarocks_content = ''
    local_cache = ""
    -- To prevent collisions when creating environments, we install the rock
    -- files into per-package subdirectories
    rocks_subdir = '${rocksSubdir}'
    -- Then we need to tell luarocks where to find the rock files per
    -- dependency
    rocks_trees = {
      ${lib.concatStringsSep "\n, " rocksTrees}
    }
  '' + lib.optionalString lua.pkgs.isLuaJIT ''
    -- Luajit provides some additional functionality built-in; this exposes
    -- that to luarock's dependency system
    rocks_provided = {
      jit='${lua.luaversion}-1';
      ffi='${lua.luaversion}-1';
      luaffi='${lua.luaversion}-1';
      bit='${lua.luaversion}-1';
    }
  '' + ''
    -- For single-output external dependencies
    external_deps_dirs = {
      ${lib.concatStringsSep "\n, " externalDepsDirs}
    }
    variables = {
      -- Some needed machinery to handle multiple-output external dependencies,
      -- as per https://github.com/luarocks/luarocks/issues/766
      ${lib.optionalString (lib.length depVariables > 0) ''
      ${lib.concatStringsSep "\n  " depVariables}''}
      ${extraVariables}
    }
    ${extraConfig}
  '';

  rocksSubdir = "${attrs.pname}-${version}-rocks";

  externalDepsDirs = map
    (x: "'${builtins.toString x}'")
    (lib.filter (lib.isDerivation) externalDeps);

  rocksTrees = lib.imap0
    (i: dep: "{ name = [[dep-${toString i}]], root = '${dep}', rocks_dir = '${dep}/${dep.rocksSubdir}' }")
    requiredLuaRocks;

  # Filter out the lua derivation itself from the Lua module dependency
  # closure, as it doesn't have a rock tree :)
  requiredLuaRocks = lib.filter (d: d ? luaModule)
    (lua.pkgs.requiredLuaModules propagatedBuildInputs);

  # Explicitly point luarocks to the relevant locations for multiple-output
  # derivations that are external dependencies, to work around an issue it has
  # (https://github.com/luarocks/luarocks/issues/766)
  depVariables = lib.concatMap ({name, dep}: [
    "${name}_INCDIR='${lib.getDev dep}/include';"
    "${name}_LIBDIR='${lib.getLib dep}/lib';"
    "${name}_BINDIR='${lib.getBin dep}/bin';"
  ]) externalDeps';

  # example externalDeps': [ { name = "CRYPTO"; dep = pkgs.openssl; } ]
  externalDeps' = lib.filter (dep: !lib.isDerivation dep) externalDeps;
in
toLuaModule ( lua.stdenv.mkDerivation (
builtins.removeAttrs attrs ["disabled" "checkInputs" "externalDeps"] // {

  name = namePrefix + name;

  buildInputs = [ wrapLua lua.pkgs.luarocks ]
    ++ buildInputs
    ++ lib.optionals doCheck checkInputs
    ++ (map (d: d.dep) externalDeps')
    ;

  # propagate lua to active setup-hook in nix-shell
  propagatedBuildInputs = propagatedBuildInputs ++ [ lua ];
  inherit doCheck;

  # @-patterns do not capture formal argument default values, so we need to
  # explicitly inherit this for it to be available as a shell variable in the
  # builder
  inherit rockspecFilename;
  inherit rocksSubdir;

  # enabled only for src.rock
  setSourceRoot= let
    name_only= lib.getName name;
  in
    lib.optionalString (knownRockspec == null) ''
    # format is rockspec_basename/source_basename
    # rockspec can set it via spec.source.dir
    folder=$(find . -mindepth 2 -maxdepth 2 -type d -path '*${name_only}*/*'|head -n1)
    sourceRoot="$folder"
  '';

  configurePhase = ''
    runHook preConfigure

    cat > ${luarocks_config} <<EOF
    ${luarocks_content}
    EOF
    export LUAROCKS_CONFIG="$PWD/${luarocks_config}";
  ''
  + lib.optionalString (knownRockspec != null) ''

    # prevents the following type of error:
    # Inconsistency between rockspec filename (42fm1b3d7iv6fcbhgm9674as3jh6y2sh-luv-1.22.0-1.rockspec) and its contents (luv-1.22.0-1.rockspec)
    rockspecFilename="$TMP/$(stripHash ''${knownRockspec})"
    cp ''${knownRockspec} "$rockspecFilename"
  ''
  + ''
    runHook postConfigure
  '';

  buildPhase = ''
    runHook preBuild

    nix_debug "Using LUAROCKS_CONFIG=$LUAROCKS_CONFIG"

    LUAROCKS=luarocks
    if (( ''${NIX_DEBUG:-0} >= 1 )); then
        LUAROCKS="$LUAROCKS --verbose"
    fi

    patchShebangs .

    runHook postBuild
  '';

  postFixup = lib.optionalString (!dontWrapLuaPrograms) ''
    wrapLuaPrograms
  '' + attrs.postFixup or '''';

  installPhase = attrs.installPhase or ''
    runHook preInstall

    # work around failing luarocks test for Write access
    mkdir -p $out

    # luarocks make assumes sources are available in cwd
    # After the build is complete, it also installs the rock.
    # If no argument is given, it looks for a rockspec in the current directory
    # but some packages have several rockspecs in their source directory so
    # we force the use of the upper level since it is
    # the sole rockspec in that folder
    # maybe we could reestablish dependency checking via passing --rock-trees

    nix_debug "ROCKSPEC $rockspecFilename"
    nix_debug "cwd: $PWD"
    $LUAROCKS make --deps-mode=all --tree=$out ''${rockspecFilename}

    runHook postInstall
  '';

  passthru = {
    inherit lua; # The lua interpreter
    inherit externalDeps;
  } // passthru;

  meta = with lib.maintainers; {
    platforms = lua.meta.platforms;
    # add extra maintainer(s) to every package
    maintainers = (meta.maintainers or []) ++ [ ];
    broken = disabled;
  } // meta;
}))
