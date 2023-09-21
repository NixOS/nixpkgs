{ lib
, stdenv
, fetchurl
, tzdata
, substituteAll
, iana-etc
, Security
, Foundation
, xcbuild
, mailcap
, buildPackages
, testers
, skopeo
, buildGo121Module
}:

let
  goBootstrap = buildPackages.callPackage ./bootstrap121.nix { };

  skopeoTest = skopeo.override { buildGoModule = buildGo121Module; };

  goarch = platform: {
    "aarch64" = "arm64";
    "arm" = "arm";
    "armv5tel" = "arm";
    "armv6l" = "arm";
    "armv7l" = "arm";
    "i686" = "386";
    "mips" = "mips";
    "mips64el" = "mips64le";
    "mipsel" = "mipsle";
    "powerpc64le" = "ppc64le";
    "riscv64" = "riscv64";
    "s390x" = "s390x";
    "x86_64" = "amd64";
  }.${platform.parsed.cpu.name} or (throw "Unsupported system: ${platform.parsed.cpu.name}");

  buildGOOS = stdenv.buildPlatform.parsed.kernel.name;
  buildGOARCH = goarch stdenv.buildPlatform;
  hostGOOS = stdenv.hostPlatform.parsed.kernel.name;
  hostGOARCH = goarch stdenv.hostPlatform;
  targetGOOS = stdenv.targetPlatform.parsed.kernel.name;
  targetGOARCH = goarch stdenv.targetPlatform;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "go";
  version = "1.21.1";

  src = fetchurl {
    url = "https://go.dev/dl/go${finalAttrs.version}.src.tar.gz";
    hash = "sha256-v6Nr916aHpy725q8+dFwfkeb06B4gKiuNWTK7lcRy5k=";
  };

  strictDeps = true;

  depsTargetTargetPropagated = lib.optionals stdenv.targetPlatform.isDarwin [ Foundation Security xcbuild ];

  patches = [
    (substituteAll {
      src = ./iana-etc-1.17.patch;
      iana = iana-etc;
    })
    # Patch the mimetype database location which is missing on NixOS.
    # but also allow static binaries built with NixOS to run outside nix
    (substituteAll {
      src = ./mailcap-1.17.patch;
      inherit mailcap;
    })
    # prepend the nix path to the zoneinfo files but also leave the original value for static binaries
    # that run outside a nix server
    (substituteAll {
      src = ./tzdata-1.19.patch;
      inherit tzdata;
    })
    ./remove-tools-1.11.patch
    ./go_no_vendor_checks-1.21.patch
  ];

  # Go release builds are statically linked so we don’t need to patch
  # interpreter or library paths.
  dontPatchELF = true;
  # Scripts in GOROOT are not used by the toolchain and in most cases are used
  # during Go toolchain development to generate source code (e.g. for syscalls).
  dontPatchShebangs = true;
  # While this may be useful, make.bash builds releases with -trimpath, so there
  # should be no references to $TMPDIR, and this spams build log with error
  # messages like:
  #   patchelf: wrong ELF type
  #   patchelf: cannot find section '.dynamic'. The input file is most likely statically linked
  noAuditTmpdir = true;

  # Build configuration. Note that these variables are shadowed by passthru
  # attributes on the final package, so they are only used when building Go.
  #
  # The following variables are omitted and defaults are used:
  # • For GOARCH=amd64: GOAMD64 defaults to "v1".
  # • For GOARCH=mips{,le}: GOMIPS defaults to "hardfloat".
  # • For GOARCH=mips64{,le}: GOMIPS64 defaults to "hardfloat".
  # • For GOARCH=ppc64{,le}: GOPPC64 defaults to "power8".
  # • For GOARCH=wasm: GOWASM defaults to empty list.
  #
  # See `go help environment` for more information.
  GOOS = hostGOOS;
  GOARCH = hostGOARCH;
  GOARM = toString (lib.intersectLists [ (stdenv.hostPlatform.parsed.cpu.version or "") ] [ "5" "6" "7" ]);
  GO386 = "softfloat"; # from Arch: don't assume sse2 on i686

  # NB starting with Go 1.21, the toolchain binaries are statically linked pure
  # Go programs, with no references to glibc, and so they should work fine on
  # musl buildPlatform.
  #
  # Note that GOROOT_FINAL is not embedded in the output for release builds. See
  # https://go.dev/issue/62047
  GOROOT_BOOTSTRAP = "${goBootstrap}/share/go";

  # Note that we use distpack to avoid moving around cross-compiled binaries.
  # The paths are slightly different when buildPlatform != hostPlatform and
  # distpack handles assembling outputs in the right place, same as the official
  # Go binary releases. See also https://pkg.go.dev/cmd/distpack
  buildPhase = ''
    runHook preBuild
    export GOCACHE=$TMPDIR/go-cache

    # Do not confuse Go build system with environment variables from
    # stdenv.mkDerivation.
    unset {CC,CXX}{,_FOR_TARGET}

    ulimit -a

    pushd src
    bash make.bash -no-banner -distpack
    popd
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/{share,bin}
    tar -C $out/share -x -z -f "pkg/distpack/go${finalAttrs.version}.$GOOS-$GOARCH.tar.gz"
    ln -s $out/share/go/bin/* $out/bin
    runHook postInstall
  '';

  disallowedReferences = [ goBootstrap ];

  passthru = {
    inherit goBootstrap skopeoTest;
    tests = {
      skopeo = testers.testVersion { package = skopeoTest; };
      version = testers.testVersion {
        package = finalAttrs.finalPackage;
        command = "go version";
        version = "go${finalAttrs.version}";
      };
    };

    # Exposed for compatibility with other packages that use these variables to
    # find Go names for the platform.
    GOOS = targetGOOS;
    GOARCH = targetGOARCH;
    GOHOSTOS = buildGOOS;
    GOHOSTARCH = buildGOARCH;
    # buildGoModule uses this to check whether Cgo should be enabled.
    # Go release builds do not need Cgo or C compiler.
    CGO_ENABLED = 1;
  };

  meta = with lib; {
    changelog = "https://go.dev/doc/devel/release#go${lib.versions.majorMinor finalAttrs.version}";
    description = "The Go Programming language";
    homepage = "https://go.dev/";
    license = licenses.bsd3;
    maintainers = teams.golang.members;
    platforms = platforms.darwin ++ platforms.linux;
  };
})
