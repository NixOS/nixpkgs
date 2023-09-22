{ lib
, stdenv
, makeGoPlatform
, fetchurl
, tzdata
, substituteAll
, iana-etc
, Security
, Foundation
, xcbuild
, mailcap
, buildPackages
, pkgsBuildTarget
, threadsCross
, testers
, skopeo
}:

let
  useGccGoBootstrap = stdenv.buildPlatform.isMusl || stdenv.buildPlatform.isRiscV;
  goBootstrap = if useGccGoBootstrap then buildPackages.gccgo12 else buildPackages.callPackage ./bootstrap117.nix { };

  # We need a target compiler which is still runnable at build time,
  # to handle the cross-building case where build != host == target
  targetCC = pkgsBuildTarget.targetPackages.stdenv.cc;

  isCross = stdenv.buildPlatform != stdenv.targetPlatform;
in
stdenv.mkDerivation (finalAttrs:
let
  goPlatform = makeGoPlatform { go = finalAttrs.finalPackage; };
  skopeoTest = skopeo.override { inherit (goPlatform) buildGoModule; };
in
{
  pname = "go";
  version = "1.20.8";

  src = fetchurl {
    url = "https://go.dev/dl/go${finalAttrs.version}.src.tar.gz";
    hash = "sha256-ONcXFPpSeflyQEUZVtjkfjwbal3ny4QTeUnWK13TGC4=";
  };

  strictDeps = true;
  buildInputs = [ ]
    ++ lib.optionals stdenv.isLinux [ stdenv.cc.libc.out ]
    ++ lib.optionals (stdenv.hostPlatform.libc == "glibc") [ stdenv.cc.libc.static ];

  depsTargetTargetPropagated = lib.optionals stdenv.targetPlatform.isDarwin [ Foundation Security xcbuild ];

  depsBuildTarget = lib.optional isCross targetCC;

  depsTargetTarget = lib.optional stdenv.targetPlatform.isWindows threadsCross.package;

  postPatch = ''
    patchShebangs .
  '';

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
    ./go_no_vendor_checks-1.16.patch
  ];

  env = goPlatform.target.env // {
    # GOHOSTOS/GOHOSTARCH must match the building system, not the host system.
    # Go will nevertheless build a for host system that we will copy over in
    # the install phase.
    GOHOSTOS = goPlatform.build.env.GOOS;
    GOHOSTARCH = goPlatform.build.env.GOARCH;

    GOARM = goPlatform.host.env.GOARM or "";
    GO386 = goPlatform.host.env.GO386 or "softfloat"; # from Arch: don't assume sse2 on i686
    CGO_ENABLED = 1;

    GOROOT_BOOTSTRAP = if useGccGoBootstrap then goBootstrap else "${goBootstrap}/share/go";
  } // lib.optionalAttrs (isCross) {
    # {CC,CXX}_FOR_TARGET must be only set for cross compilation case as go expects those
    # to be different from CC/CXX.
    CC_FOR_TARGET = "${targetCC}/bin/${targetCC.targetPrefix}cc";
    CXX_FOR_TARGET = "${targetCC}/bin/${targetCC.targetPrefix}c++";
  };

  buildPhase = ''
    runHook preBuild
    export GOCACHE=$TMPDIR/go-cache
    # this is compiled into the binary
    export GOROOT_FINAL=$out/share/go

    export PATH=$(pwd)/bin:$PATH

    ${lib.optionalString isCross ''
    # Independent from host/target, CC should produce code for the building system.
    # We only set it when cross-compiling.
    export CC=${buildPackages.stdenv.cc}/bin/cc
    ''}
    ulimit -a

    pushd src
    ./make.bash
    popd
    runHook postBuild
  '';

  preInstall = ''
    # Contains the wrong perl shebang when cross compiling,
    # since it is not used for anything we can deleted as well.
    rm src/regexp/syntax/make_perl_groups.pl
  '' + (if (stdenv.buildPlatform.system != stdenv.hostPlatform.system) then ''
    mv bin/*_*/* bin
    rmdir bin/*_*
    ${lib.optionalString (!(finalAttrs.env.GOHOSTARCH == finalAttrs.env.GOARCH && finalAttrs.env.GOOS == finalAttrs.env.GOHOSTOS)) ''
      rm -rf pkg/${finalAttrs.env.GOHOSTOS}_${finalAttrs.env.GOHOSTARCH} pkg/tool/${finalAttrs.env.GOHOSTOS}_${finalAttrs.env.GOHOSTARCH}
    ''}
  '' else lib.optionalString (stdenv.hostPlatform.system != stdenv.targetPlatform.system) ''
    rm -rf bin/*_*
    ${lib.optionalString (!(finalAttrs.env.GOHOSTARCH == finalAttrs.env.GOARCH && finalAttrs.env.GOOS == finalAttrs.env.GOHOSTOS)) ''
      rm -rf pkg/${finalAttrs.env.GOOS}_${finalAttrs.env.GOARCH} pkg/tool/${finalAttrs.env.GOOS}_${finalAttrs.env.GOARCH}
    ''}
  '');

  installPhase = ''
    runHook preInstall
    mkdir -p $GOROOT_FINAL
    cp -a bin pkg src lib misc api doc $GOROOT_FINAL
    mkdir -p $out/bin
    ln -s $GOROOT_FINAL/bin/* $out/bin
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
