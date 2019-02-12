# Generic builder for lua packages
{ lib
, lua
, stdenv
, wrapLua
, unzip
, writeText
# Whether the derivation provides a lua module or not.
, toLuaModule
}:

{
name ? "${attrs.pname}-${attrs.version}"

, version

# by default prefix `name` e.g. "lua5.2-${name}"
, namePrefix ? "lua" + lua.luaversion + "-"

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
, disabled ? false

# Additional arguments to pass to the makeWrapper function, which wraps
# generated binaries.
, makeWrapperArgs ? []
, external_deps ? propagatedBuildInputs ++ buildInputs

# Skip wrapping of lua programs altogether
, dontWrapLuaPrograms ? false

, meta ? {}

, passthru ? {}
, doCheck ? false

# appended to the luarocks generated config
# in peculiar variables like { EVENT_INCDIR } can be useful to work around
# luarocks limitations, ie, luarocks consider include/lib folders to be subfolders of the same package in external_deps_dirs
# as explained in https://github.com/luarocks/luarocks/issues/766
, extraConfig ? ""

# relative to srcRoot, path to the rockspec to use when using rocks
, rockspecFilename ?  "../*.rockspec"

# must be set for packages that don't have a rock
, knownRockspec ? null

, ... } @ attrs:


# Keep extra attributes from `attrs`, e.g., `patchPhase', etc.
if disabled
then throw "${name} not supported for interpreter ${lua}"
else

let

  deps_dirs= lib.concatStringsSep ", " (
    map (x: "\"${builtins.toString x}\"") external_deps
  );

  # TODO
  # - add rocktrees (look at torch-distro.nix/https://github.com/luarocks/luarocks/wiki/Config-file-format)
  # - silence warnings
  luarocks_config = "luarocksConfig";
  luarocks_content = ''
    local_cache = ""
    -- array of strings
    external_deps_dirs = {
    ${deps_dirs}
    }
    rocks_trees = {
    }
    ${extraConfig}
  '';
in
toLuaModule ( lua.stdenv.mkDerivation (
builtins.removeAttrs attrs ["disabled" "checkInputs"] // {

  name = namePrefix + name;

  buildInputs = [ wrapLua lua.pkgs.luarocks ]
    ++ buildInputs
    ++ lib.optionals doCheck checkInputs
    ;

  # propagate lua to active setup-hook in nix-shell
  propagatedBuildInputs = propagatedBuildInputs ++ [ lua ];
  doCheck = false;

  # enabled only for src.rock
  setSourceRoot= let
    name_only=(builtins.parseDrvName name).name;
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
    export LUAROCKS_CONFIG=$PWD/${luarocks_config};
  ''
  + lib.optionalString (knownRockspec != null) ''

    # prevents the following type of error:
    # Inconsistency between rockspec filename (42fm1b3d7iv6fcbhgm9674as3jh6y2sh-luv-1.22.0-1.rockspec) and its contents (luv-1.22.0-1.rockspec)
    rockspecFilename="$TMP/$(stripHash ''${knownRockspec})"
    cp ''${knownRockspec} $rockspecFilename
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

    # luarocks make assumes sources are available in cwd
    # After the build is complete, it also installs the rock.
    # If no argument is given, it looks for a rockspec in the current directory
    # but some packages have several rockspecs in their source directory so
    # we force the use of the upper level since it is
    # the sole rockspec in that folder
    # maybe we could reestablish dependency checking via passing --rock-trees

    nix_debug "ROCKSPEC $rockspecFilename"
    nix_debug "cwd: $PWD"
    $LUAROCKS make --deps-mode=none --tree $out ''${rockspecFilename}

    # to prevent collisions when creating environments
    # also added -f as it doesn't always exist
    # don't remove the whole directory as
    rm -rf $out/lib/luarocks/rocks/manifest

    runHook postInstall
  '';

  passthru = {
    inherit lua; # The lua interpreter
  } // passthru;

  meta = with lib.maintainers; {
    platforms = lua.meta.platforms;
    # add extra maintainer(s) to every package
    maintainers = (meta.maintainers or []) ++ [ ];
  } // meta;
}))
