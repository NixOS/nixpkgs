{ lib
, stdenv
, fetchpatch
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
, buildGo119Module
}:

let
  useGccGoBootstrap = stdenv.buildPlatform.isMusl || stdenv.buildPlatform.isRiscV;
  goBootstrap = if useGccGoBootstrap then buildPackages.gccgo12 else buildPackages.callPackage ./bootstrap116.nix { };

  skopeoTest = skopeo.override { buildGoModule = buildGo119Module; };

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

  # We need a target compiler which is still runnable at build time,
  # to handle the cross-building case where build != host == target
  targetCC = pkgsBuildTarget.targetPackages.stdenv.cc;

  isCross = stdenv.buildPlatform != stdenv.targetPlatform;
in
stdenv.mkDerivation rec {
  pname = "go";
  version = "1.19.12";

  src = fetchurl {
    url = "https://go.dev/dl/go${version}.src.tar.gz";
    hash = "sha256-7l1Q4Kf9dLobE3y4eWCaqu+YgL9ytdF0IQDjiucrtVc=";
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

    # runtime: support riscv64 SV57 mode
    (fetchpatch {
      url = "https://github.com/golang/go/commit/1e3c19f3fee12e5e2b7802a54908a4d4d03960da.patch";
      sha256 = "sha256-mk/9gXwQEcAkiRemF6GiNU0c0fhDR29/YcKgQR7ONTA=";
    })
  ];

  GOOS = stdenv.targetPlatform.parsed.kernel.name;
  GOARCH = goarch stdenv.targetPlatform;
  # GOHOSTOS/GOHOSTARCH must match the building system, not the host system.
  # Go will nevertheless build a for host system that we will copy over in
  # the install phase.
  GOHOSTOS = stdenv.buildPlatform.parsed.kernel.name;
  GOHOSTARCH = goarch stdenv.buildPlatform;

  # {CC,CXX}_FOR_TARGET must be only set for cross compilation case as go expect those
  # to be different from CC/CXX
  CC_FOR_TARGET =
    if isCross then
      "${targetCC}/bin/${targetCC.targetPrefix}cc"
    else
      null;
  CXX_FOR_TARGET =
    if isCross then
      "${targetCC}/bin/${targetCC.targetPrefix}c++"
    else
      null;

  GOARM = toString (lib.intersectLists [ (stdenv.hostPlatform.parsed.cpu.version or "") ] [ "5" "6" "7" ]);
  GO386 = "softfloat"; # from Arch: don't assume sse2 on i686
  CGO_ENABLED = 1;

  GOROOT_BOOTSTRAP = if useGccGoBootstrap then goBootstrap else "${goBootstrap}/share/go";

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
    rm -r pkg/obj
    # Contains the wrong perl shebang when cross compiling,
    # since it is not used for anything we can deleted as well.
    rm src/regexp/syntax/make_perl_groups.pl
  '' + (if (stdenv.buildPlatform.system != stdenv.hostPlatform.system) then ''
    mv bin/*_*/* bin
    rmdir bin/*_*
    ${lib.optionalString (!(GOHOSTARCH == GOARCH && GOOS == GOHOSTOS)) ''
      rm -rf pkg/${GOHOSTOS}_${GOHOSTARCH} pkg/tool/${GOHOSTOS}_${GOHOSTARCH}
    ''}
  '' else lib.optionalString (stdenv.hostPlatform.system != stdenv.targetPlatform.system) ''
    rm -rf bin/*_*
    ${lib.optionalString (!(GOHOSTARCH == GOARCH && GOOS == GOHOSTOS)) ''
      rm -rf pkg/${GOOS}_${GOARCH} pkg/tool/${GOOS}_${GOARCH}
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
    };
  };

  meta = with lib; {
    changelog = "https://go.dev/doc/devel/release#go${lib.versions.majorMinor version}";
    description = "The Go Programming language";
    homepage = "https://go.dev/";
    license = licenses.bsd3;
    maintainers = teams.golang.members;
    platforms = platforms.darwin ++ platforms.linux;
  };
}
