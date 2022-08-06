{ lib
, buildPackages
, cacert
, fetchurl
, Foundation
, iana-etc
, mailcap
, pkgsBuildTarget
, runCommand
, Security
, stdenv
, threadsCross
, tzdata
, xcbuild
}:

let
  bootstrap = buildPackages.callPackage ./bootstrap.nix { };

  goBootstrap = runCommand "go-bootstrap" { } ''
    mkdir $out
    cp -rf ${bootstrap}/* $out/
    chmod -R u+w $out
    find $out -name "*.c" -delete
    cp -rf $out/bin/* $out/share/go/bin/
  '';

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
  version = "1.18.4";

  src = fetchurl {
    url = "https://go.dev/dl/go${version}.src.tar.gz";
    sha256 = "sha256-RSWqaw487LV4RfQGCnB1qvyat1K7e2tM+KIS1DB44eQ=";
  };

  strictDeps = true;

  depsTargetTargetPropagated = [ cacert ] ++ lib.optionals stdenv.isDarwin [ Foundation Security xcbuild ];

  depsBuildTarget = lib.optional isCross targetCC;

  depsTargetTarget = lib.optional stdenv.targetPlatform.isWindows threadsCross;

  postPatch = ''
    patchShebangs .

    # Patch the mimetype database location which is missing on NixOS.
    # but also allow static binaries built with NixOS to run outside nix
    sed -i 's,\"/etc/mime.types,"${mailcap}/etc/mime.types\"\,\n\t&,' src/mime/type_unix.go

    sed -i 's,/etc/protocols,${iana-etc}/etc/protocols,' src/net/lookup_unix.go
    sed -i 's,/etc/services,${iana-etc}/etc/services,' src/net/port_unix.go

    # prepend the nix path to the zoneinfo files but also leave the original value for static binaries
    # that run outside a nix server
    sed -i 's,\"/usr/share/zoneinfo/,"${tzdata}/share/zoneinfo/\"\,\n\t&,' src/time/zoneinfo_unix.go
  '';

  patches = [
    ./remove-tools-1.11.patch
    ./go_no_vendor_checks-1.16.patch
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

  GOROOT_BOOTSTRAP = "${goBootstrap}/share/go";

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

  installPhase = ''
    runHook preInstall
    rm -r pkg/obj
    # Contains the wrong perl shebang when cross compiling,
    # since it is not used for anything we can deleted as well.
    rm src/regexp/syntax/make_perl_groups.pl
  '' + (if (stdenv.buildPlatform != stdenv.hostPlatform) then ''
    mv bin/*_*/* bin
    rmdir bin/*_*
    ${lib.optionalString (!(GOHOSTARCH == GOARCH && GOOS == GOHOSTOS)) ''
      rm -rf pkg/${GOHOSTOS}_${GOHOSTARCH} pkg/tool/${GOHOSTOS}_${GOHOSTARCH}
    ''}
  '' else if (stdenv.hostPlatform != stdenv.targetPlatform) then ''
    rm -rf bin/*_*
    ${lib.optionalString (!(GOHOSTARCH == GOARCH && GOOS == GOHOSTOS)) ''
      rm -rf pkg/${GOOS}_${GOARCH} pkg/tool/${GOOS}_${GOARCH}
    ''}
  '' else "") + ''
    mkdir -p $GOROOT_FINAL
    cp -a bin pkg src lib misc api doc $GOROOT_FINAL
    ln -s $GOROOT_FINAL/bin $out/bin
    runHook postInstall
  '';

  disallowedReferences = [ goBootstrap ];

  meta = with lib; {
    description = "The Go Programming language";
    homepage = "https://go.dev/";
    license = licenses.bsd3;
    maintainers = teams.golang.members;
    platforms = platforms.darwin ++ platforms.linux;
  };
}
