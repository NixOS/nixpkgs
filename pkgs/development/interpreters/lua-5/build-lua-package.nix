# Generic builder for lua packages
{ lib
, lua
, wrapLua

# Whether the derivation provides a lua module or not.
, luarocksCheckHook
, luaLib
}:

{ pname
, version
# we need rockspecVersion to find the .rockspec even when version changes
, rockspecVersion ? version

# by default prefix `name` e.g. "lua5.2-${name}"
, namePrefix ? "${lua.pname}${lib.versions.majorMinor lua.version}-"

# Dependencies for building the package
, buildInputs ? []

# Dependencies needed for running the checkPhase.
# These are added to nativeBuildInputs when doCheck = true.
, nativeCheckInputs ? []

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
, doCheck ? false
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

  # TODO fix warnings "Couldn't load rockspec for ..." during manifest
  # construction -- from initial investigation, appears it will require
  # upstream luarocks changes to fix cleanly (during manifest construction,
  # luarocks only looks for rockspecs in the default/system tree instead of all
  # configured trees)
  luarocks_config = "luarocks-config.lua";

  luarocksDrv = luaLib.toLuaModule ( lua.stdenv.mkDerivation (self: attrs // {

  name = namePrefix + pname + "-" + self.version;
  inherit rockspecVersion;

  __structuredAttrs = true;
  env = {
    LUAROCKS_CONFIG="$PWD/${luarocks_config}";
  } // attrs.env or {};

  generatedRockspecFilename = "${rockspecDir}/${pname}-${rockspecVersion}.rockspec";

  nativeBuildInputs = [
    wrapLua
    lua.pkgs.luarocks
  ];

  inherit doCheck extraVariables rockspecFilename knownRockspec externalDeps nativeCheckInputs;

  buildInputs = let
    # example externalDeps': [ { name = "CRYPTO"; dep = pkgs.openssl; } ]
    externalDeps' = lib.filter (dep: !lib.isDerivation dep) self.externalDeps;
    in [ lua.pkgs.luarocks ]
      ++ buildInputs
      ++ lib.optionals self.doCheck ([ luarocksCheckHook ] ++ self.nativeCheckInputs)
      ++ (map (d: d.dep) externalDeps')
    ;

  # propagate lua to active setup-hook in nix-shell
  propagatedBuildInputs = propagatedBuildInputs ++ [ lua ];

  # @-patterns do not capture formal argument default values, so we need to
  # explicitly inherit this for it to be available as a shell variable in the
  # builder
  rocksSubdir = "${self.pname}-${self.version}-rocks";
  luarocks_content = let
      externalDepsGenerated = lib.filter (drv: !drv ? luaModule)
        (self.nativeBuildInputs ++ self.propagatedBuildInputs ++ self.buildInputs);
    generatedConfig = luaLib.generateLuarocksConfig {
      externalDeps = lib.unique (self.externalDeps ++ externalDepsGenerated);
      # Filter out the lua derivation itself from the Lua module dependency
      # closure, as it doesn't have a rock tree :)
      # luaLib.hasLuaModule
      requiredLuaRocks = lib.filter luaLib.hasLuaModule
        (lua.pkgs.requiredLuaModules (self.nativeBuildInputs ++ self.propagatedBuildInputs));
      inherit (self) extraVariables rocksSubdir;
    };
    in
      ''
      ${generatedConfig}
      ${extraConfig}
      '';

  configurePhase = ''
    runHook preConfigure

    cat > ${luarocks_config} <<EOF
    ${self.luarocks_content}
    EOF
    export LUAROCKS_CONFIG="$PWD/${luarocks_config}";
    cat "$LUAROCKS_CONFIG"
  ''
  + lib.optionalString (self.rockspecFilename == null) ''
    rockspecFilename="${self.generatedRockspecFilename}"
  ''
  + lib.optionalString (self.knownRockspec != null) ''
    # prevents the following type of error:
    # Inconsistency between rockspec filename (42fm1b3d7iv6fcbhgm9674as3jh6y2sh-luv-1.22.0-1.rockspec) and its contents (luv-1.22.0-1.rockspec)
    rockspecFilename="$TMP/$(stripHash ${self.knownRockspec})"
    cp ${self.knownRockspec} "$rockspecFilename"
  ''
  + ''
    runHook postConfigure
  '';

  buildPhase = ''
    runHook preBuild

    nix_debug "Using LUAROCKS_CONFIG=$LUAROCKS_CONFIG"

    LUAROCKS_EXTRA_ARGS=""
    if (( ''${NIX_DEBUG:-0} >= 1 )); then
        LUAROCKS_EXTRA_ARGS=" --verbose"
    fi

    runHook postBuild
  '';

  postFixup = lib.optionalString (!dontWrapLuaPrograms) ''
    wrapLuaPrograms
  '' + attrs.postFixup or "";

  installPhase = ''
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
    luarocks $LUAROCKS_EXTRA_ARGS make --deps-mode=all --tree=$out ''${rockspecFilename}

    runHook postInstall
  '';

  checkPhase = ''
    runHook preCheck
    luarocks test
    runHook postCheck
  '';

  shellHook = ''
    runHook preShell
    export LUAROCKS_CONFIG="$PWD/${luarocks_config}";
    runHook postShell
  '';

  passthru = {
    inherit lua;
  } // attrs.passthru or { };

  meta = {
    platforms = lua.meta.platforms;
    # add extra maintainer(s) to every package
    maintainers = (attrs.meta.maintainers or []) ++ [ ];
    broken = disabled;
  } // attrs.meta or {};
}));
in
  luarocksDrv
