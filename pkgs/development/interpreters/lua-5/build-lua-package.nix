# Generic builder for lua packages
{ lib
, lua
, wrapLua
, luarocks
# Whether the derivation provides a lua module or not.
, luarocksCheckHook
, luaLib
}:

{
pname
, version

# by default prefix `name` e.g. "lua5.2-${name}"
, namePrefix ? "${lua.pname}${lua.sourceVersion.major}.${lua.sourceVersion.minor}-"

# Dependencies for building the package
, buildInputs ? []

# Dependencies needed for running the checkPhase.
# These are added to buildInputs when doCheck = true.
, checkInputs ? []

# propagate build dependencies so in case we have A -> B -> C,
# C can import package A propagated by B
, propagatedBuildInputs ? []

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
, doInstallCheck ? false

# Non-Lua / system (e.g. C library) dependencies. Is a list of deps, where
# each dep is either a derivation, or an attribute set like
# { name = "rockspec external_dependencies key"; dep = derivation; }
# The latter is used to work-around luarocks having a problem with
# multiple-output derivations as external deps:
# https://github.com/luarocks/luarocks/issues/766<Paste>
, externalDeps ? []

# Appended to the generated luarocks config
, extraConfig ? ""
# Inserted into the generated luarocks config in the "variables" table
, extraVariables ? {}
# The two above arguments have access to builder variables -- e.g. to $out

# relative to srcRoot, path to the rockspec to use when using rocks
, rockspecFilename ? null
# relative to srcRoot, path to folder that contains the expected rockspec
, rockspecDir ?  "."

# must be set for packages that don't have a rock
, knownRockspec ? null

, ... } @ attrs:


# Keep extra attributes from `attrs`, e.g., `patchPhase', etc.

let
  generatedRockspecFilename = "${rockspecDir}/${pname}-${version}.rockspec";

  # TODO fix warnings "Couldn't load rockspec for ..." during manifest
  # construction -- from initial investigation, appears it will require
  # upstream luarocks changes to fix cleanly (during manifest construction,
  # luarocks only looks for rockspecs in the default/system tree instead of all
  # configured trees)
  luarocks_config = "luarocks-config.lua";
  luarocks_content = let
    generatedConfig = luaLib.generateLuarocksConfig {
      externalDeps = externalDeps ++ externalDepsGenerated;
      inherit extraVariables;
      inherit rocksSubdir;
      inherit requiredLuaRocks;
    };
    in
      ''
      ${generatedConfig}
      ${extraConfig}
      '';

  rocksSubdir = "${attrs.pname}-${version}-rocks";

  # Filter out the lua derivation itself from the Lua module dependency
  # closure, as it doesn't have a rock tree :)
  requiredLuaRocks = lib.filter (d: d ? luaModule)
    (lua.pkgs.requiredLuaModules (luarocksDrv.nativeBuildInputs ++ luarocksDrv.propagatedBuildInputs));

  # example externalDeps': [ { name = "CRYPTO"; dep = pkgs.openssl; } ]
  externalDepsGenerated = lib.unique (lib.filter (drv: !drv ? luaModule) (
    luarocksDrv.nativeBuildInputs ++ luarocksDrv.propagatedBuildInputs ++ luarocksDrv.buildInputs)
    );
  externalDeps' = lib.filter (dep: !lib.isDerivation dep) externalDeps;

  luarocksDrv = luaLib.toLuaModule ( lua.stdenv.mkDerivation (
builtins.removeAttrs attrs ["disabled" "checkInputs" "externalDeps" "extraVariables"] // {

  name = namePrefix + pname + "-" + version;

  nativeBuildInputs = [
    wrapLua
    luarocks
  ] ++ lib.optionals doCheck ([ luarocksCheckHook ] ++ checkInputs);

  buildInputs = buildInputs
    ++ (map (d: d.dep) externalDeps');


  # propagate lua to active setup-hook in nix-shell
  propagatedBuildInputs = propagatedBuildInputs ++ [ lua ];

  # @-patterns do not capture formal argument default values, so we need to
  # explicitly inherit this for it to be available as a shell variable in the
  # builder
  inherit rocksSubdir;

  configurePhase = ''
    runHook preConfigure

    cat > ${luarocks_config} <<EOF
    ${luarocks_content}
    EOF
    export LUAROCKS_CONFIG="$PWD/${luarocks_config}";
  ''
  + lib.optionalString (rockspecFilename == null) ''
    rockspecFilename="${generatedRockspecFilename}"
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

    runHook postBuild
  '';

  postFixup = lib.optionalString (!dontWrapLuaPrograms) ''
    wrapLuaPrograms
  '' + attrs.postFixup or "";

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


  checkPhase = attrs.checkPhase or ''
    runHook preCheck
    $LUAROCKS test
    runHook postCheck
  '';

  LUAROCKS_CONFIG="$PWD/${luarocks_config}";

  shellHook = ''
    runHook preShell
    export LUAROCKS_CONFIG="$PWD/${luarocks_config}";
    runHook postShell
  '';

  passthru = {
    inherit lua; # The lua interpreter
    inherit externalDeps;
    inherit luarocks_content;
  } // passthru;

  meta = {
    platforms = lua.meta.platforms;
    # add extra maintainer(s) to every package
    maintainers = (meta.maintainers or []) ++ [ ];
    broken = disabled;
  } // meta;
}));
in
  luarocksDrv
