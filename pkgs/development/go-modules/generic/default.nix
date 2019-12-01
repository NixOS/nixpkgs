{ go, cacert, git, lib, removeReferencesTo, stdenv }:

{ name ? "${args'.pname}-${args'.version}"
, src
, buildInputs ? []
, nativeBuildInputs ? []
, passthru ? {}
, patches ? []

# A function to override the go-modules derivation
, overrideModAttrs ? (_oldAttrs : {})

# modSha256 is the sha256 of the vendored dependencies
, modSha256

# We want parallel builds by default
, enableParallelBuilding ? true

# Disabled flag
, disabled ? false

# Do not enable this without good reason
# IE: programs coupled with the compiler
, allowGoReference ? false

, meta ? {}

, ... }@args':

with builtins;

let
  args = removeAttrs args' [ "overrideModAttrs" "modSha256" "disabled" ];

  removeReferences = [ ] ++ lib.optional (!allowGoReference) go;

  removeExpr = refs: ''remove-references-to ${lib.concatMapStrings (ref: " -t ${ref}") refs}'';

  go-modules = go.stdenv.mkDerivation (let modArgs = {
    name = "${name}-go-modules";

    nativeBuildInputs = [ go git cacert ];

    inherit (args) src;
    inherit (go) GOOS GOARCH;

    patches = args.patches or [];

    GO111MODULE = "on";

    impureEnvVars = lib.fetchers.proxyImpureEnvVars ++ [
      "GIT_PROXY_COMMAND" "SOCKS_SERVER"
    ];

    configurePhase = args.modConfigurePhase or ''
      runHook preConfigure

      export GOCACHE=$TMPDIR/go-cache
      export GOPATH="$TMPDIR/go"
      mkdir -p "''${GOPATH}/pkg/mod/cache/download"

      runHook postConfigure
    '';

    buildPhase = args.modBuildPhase or ''
      runHook preBuild

      go mod download

      runHook postBuild
    '';

    installPhase = args.modInstallPhase or ''
      runHook preInstall

      cp -r "''${GOPATH}/pkg/mod/cache/download" $out

      runHook postInstall
    '';

    dontFixup = true;
    outputHashMode = "recursive";
    outputHashAlgo = "sha256";
    outputHash = modSha256;
  }; in modArgs // overrideModAttrs modArgs);

  package = go.stdenv.mkDerivation (args // {
    nativeBuildInputs = [ removeReferencesTo go ] ++ nativeBuildInputs;

    inherit (go) GOOS GOARCH;

    GO111MODULE = "on";

    configurePhase = args.configurePhase or ''
      runHook preConfigure

      export GOCACHE=$TMPDIR/go-cache
      export GOPATH="$TMPDIR/go"
      export GOSUMDB=off
      export GOPROXY=file://${go-modules}

      runHook postConfigure
    '';

    buildPhase = args.buildPhase or ''
      runHook preBuild

      buildGoDir() {
        local d; local cmd;
        cmd="$1"
        d="$2"
        . $TMPDIR/buildFlagsArray
        echo "$d" | grep -q "\(/_\|examples\|Godeps\|testdata\)" && return 0
        [ -n "$excludedPackages" ] && echo "$d" | grep -q "$excludedPackages" && return 0
        local OUT
        if ! OUT="$(go $cmd $buildFlags "''${buildFlagsArray[@]}" -v -p $NIX_BUILD_CORES $d 2>&1)"; then
          if ! echo "$OUT" | grep -qE '(no( buildable| non-test)?|build constraints exclude all) Go (source )?files'; then
            echo "$OUT" >&2
            return 1
          fi
        fi
        if [ -n "$OUT" ]; then
          echo "$OUT" >&2
        fi
        return 0
      }

      getGoDirs() {
        local type;
        type="$1"
        if [ -n "$subPackages" ]; then
          echo "$subPackages" | sed "s,\(^\| \),\1./,g"
        else
          find . -type f -name \*$type.go -exec dirname {} \; | grep -v "/vendor/" | sort --unique
        fi
      }

      if (( "''${NIX_DEBUG:-0}" >= 1 )); then
        buildFlagsArray+=(-x)
      fi

      if [ ''${#buildFlagsArray[@]} -ne 0 ]; then
        declare -p buildFlagsArray > $TMPDIR/buildFlagsArray
      else
        touch $TMPDIR/buildFlagsArray
      fi
      if [ -z "$enableParallelBuilding" ]; then
          export NIX_BUILD_CORES=1
      fi
      for pkg in $(getGoDirs ""); do
        echo "Building subPackage $pkg"
        buildGoDir install "$pkg"
      done
    '' + lib.optionalString (stdenv.hostPlatform != stdenv.buildPlatform) ''
      # normalize cross-compiled builds w.r.t. native builds
      (
        dir=$GOPATH/bin/${go.GOOS}_${go.GOARCH}
        if [[ -n "$(shopt -s nullglob; echo $dir/*)" ]]; then
          mv $dir/* $dir/..
        fi
        if [[ -d $dir ]]; then
          rmdir $dir
        fi
      )
    '' + ''
      runHook postBuild
    '';

    doCheck = args.doCheck or false;
    checkPhase = args.checkPhase or ''
      runHook preCheck

      for pkg in $(getGoDirs test); do
        buildGoDir test "$pkg"
      done

      runHook postCheck
    '';

    installPhase = args.installPhase or ''
      runHook preInstall

      mkdir -p $out
      dir="$GOPATH/bin"
      [ -e "$dir" ] && cp -r $dir $out

      runHook postInstall
    '';

    preFixup = (args.preFixup or "") + ''
      find $out/bin -type f -exec ${removeExpr removeReferences} '{}' + || true
    '';

    disallowedReferences = lib.optional (!allowGoReference) go;

    passthru = passthru // { inherit go go-modules; };

    meta = {
      # Add default meta information
      platforms = go.meta.platforms or lib.platforms.all;
    } // meta // {
      # add an extra maintainer to every package
      maintainers = (meta.maintainers or []) ++
                    [ lib.maintainers.kalbasit ];
    };
  });
in if disabled then
  throw "${package.name} not supported for go ${go.meta.branch}"
else
  package
