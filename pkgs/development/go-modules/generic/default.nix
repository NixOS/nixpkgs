{ go, cacert, git, lib, stdenv, vend }:

{ name ? "${args'.pname}-${args'.version}"
, src
, buildInputs ? []
, nativeBuildInputs ? []
, passthru ? {}
, patches ? []

# A function to override the go-modules derivation
, overrideModAttrs ? (_oldAttrs : {})

# path to go.mod and go.sum directory
, modRoot ? "./"

# vendorSha256 is the sha256 of the vendored dependencies
#
# if vendorSha256 is null, then we won't fetch any dependencies and
# rely on the vendor folder within the source.
, vendorSha256
# Whether to delete the vendor folder supplied with the source.
, deleteVendor ? false
# Whether to run the vend tool to regenerate the vendor directory.
# This is useful if any dependency contain C files.
, runVend ? false

# We want parallel builds by default
, enableParallelBuilding ? true

# Disabled flag
, disabled ? false

# Do not enable this without good reason
# IE: programs coupled with the compiler
, allowGoReference ? false

, meta ? {}

# Not needed with buildGoModule
, goPackagePath ? null

, ... }@args':

with builtins;

let
  args = removeAttrs args' [ "overrideModAttrs" "vendorSha256" "disabled" ];

  go-modules = if vendorSha256 != null then go.stdenv.mkDerivation (let modArgs = {

    name = "${name}-go-modules";

    nativeBuildInputs = (args.nativeBuildInputs or []) ++ [ go git cacert ];

    inherit (args) src;
    inherit (go) GOOS GOARCH;

    patches = args.patches or [];
    preBuild = args.preBuild or "";
    sourceRoot = args.sourceRoot or "";

    GO111MODULE = "on";

    impureEnvVars = lib.fetchers.proxyImpureEnvVars ++ [
      "GIT_PROXY_COMMAND" "SOCKS_SERVER"
    ];

    configurePhase = args.modConfigurePhase or ''
      runHook preConfigure

      export GOCACHE=$TMPDIR/go-cache
      export GOPATH="$TMPDIR/go"
      cd "${modRoot}"
      runHook postConfigure
    '';

    buildPhase = args.modBuildPhase or ''
      runHook preBuild
    '' + lib.optionalString (deleteVendor == true) ''
      if [ ! -d vendor ]; then
        echo "vendor folder does not exist, 'deleteVendor' is not needed"
        exit 10
      else
        rm -rf vendor
      fi
    '' + ''
      if [ -d vendor ]; then
        echo "vendor folder exists, please set 'vendorSha256 = null;' in your expression"
        exit 10
      fi

    ${if runVend then ''
      echo "running 'vend' to rewrite vendor folder"
      ${vend}/bin/vend
    '' else ''
      go mod vendor
    ''}

      mkdir -p vendor

      runHook postBuild
    '';

    installPhase = args.modInstallPhase or ''
      runHook preInstall

      # remove cached lookup results and tiles
      cp -r --reflink=auto vendor $out

      runHook postInstall
    '';

    dontFixup = true;
  }; in modArgs // (
      {
        outputHashMode = "recursive";
        outputHashAlgo = "sha256";
        outputHash = vendorSha256;
      }
  ) // overrideModAttrs modArgs) else "";

  package = go.stdenv.mkDerivation (args // {
    nativeBuildInputs = [ go ] ++ nativeBuildInputs;

    inherit (go) GOOS GOARCH;

    GO111MODULE = "on";
    GOFLAGS = [ "-mod=vendor" ] ++ lib.optionals (!allowGoReference) [ "-trimpath" ];

    configurePhase = args.configurePhase or ''
      runHook preConfigure

      export GOCACHE=$TMPDIR/go-cache
      export GOPATH="$TMPDIR/go"
      export GOSUMDB=off
      export GOPROXY=off
      cd "$modRoot"
    '' + lib.optionalString (go-modules != "") ''
      rm -rf vendor
      cp -r --reflink=auto ${go-modules} vendor
    '' + ''

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

    doCheck = args.doCheck or true;
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

    strictDeps = true;

    disallowedReferences = lib.optional (!allowGoReference) go;

    passthru = passthru // { inherit go go-modules vendorSha256 ; };

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
else if (goPackagePath != null) then
  throw "`goPackagePath` not needed with `buildGoModule`"
else
  package
