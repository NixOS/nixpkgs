{ lib
, stdenv
, fetchurl
, tzdata
, iana-etc
, runCommand
, perl
, which
, pkg-config
, procps
, pcre
, cacert
, Security
, Foundation
, xcbuild
, mailcap
, runtimeShell
, buildPackages
, pkgsBuildTarget
, callPackage
, threadsCross ? null # for MinGW
}:

# threadsCross is just for MinGW
assert threadsCross != null -> stdenv.targetPlatform.isWindows;

let
  go_bootstrap = buildPackages.callPackage ./bootstrap.nix { };

  goBootstrap = runCommand "go-bootstrap" { } ''
    mkdir $out
    cp -rf ${go_bootstrap}/* $out/
    chmod -R u+w $out
    find $out -name "*.c" -delete
    cp -rf $out/bin/* $out/share/go/bin/
  '';

  goarch = platform: {
    "i686" = "386";
    "x86_64" = "amd64";
    "aarch64" = "arm64";
    "arm" = "arm";
    "armv5tel" = "arm";
    "armv6l" = "arm";
    "armv7l" = "arm";
    "mips" = "mips";
    "mipsel" = "mipsle";
    "riscv64" = "riscv64";
    "s390x" = "s390x";
    "powerpc64le" = "ppc64le";
    "mips64el" = "mips64le";
  }.${platform.parsed.cpu.name} or (throw "Unsupported system: ${platform.parsed.cpu.name}");

  # We need a target compiler which is still runnable at build time,
  # to handle the cross-building case where build != host == target
  targetCC = pkgsBuildTarget.targetPackages.stdenv.cc;

  isCross = stdenv.buildPlatform != stdenv.targetPlatform;
in

stdenv.mkDerivation rec {
  pname = "go";
  version = "1.18.7";

  src = fetchurl {
    url = "https://go.dev/dl/go${version}.src.tar.gz";
    sha256 = "sha256-lGfjO4Gfcb67IfsO4d1nlP0iRK6UkHqYQoZxL5g5qUQ=";
  };

  strictDeps = true;
  # perl is used for testing go vet
  nativeBuildInputs = [ perl which pkg-config procps ];
  buildInputs = [ cacert pcre ]
    ++ lib.optionals stdenv.isLinux [ stdenv.cc.libc.out ]
    ++ lib.optionals (stdenv.hostPlatform.libc == "glibc") [ stdenv.cc.libc.static ];

  propagatedBuildInputs = lib.optionals stdenv.isDarwin [ xcbuild ];

  depsTargetTargetPropagated = lib.optionals stdenv.isDarwin [ Security Foundation ];

  depsBuildTarget = lib.optional isCross targetCC;

  depsTargetTarget = lib.optional (threadsCross != null) threadsCross;

  hardeningDisable = [ "all" ];

  prePatch = ''
    patchShebangs ./ # replace /bin/bash

    # This source produces shell script at run time,
    # and thus it is not corrected by patchShebangs.
    substituteInPlace misc/cgo/testcarchive/carchive_test.go \
      --replace '#!/usr/bin/env bash' '#!${runtimeShell}'

    # Patch the mimetype database location which is missing on NixOS.
    # but also allow static binaries built with NixOS to run outside nix
    sed -i 's,\"/etc/mime.types,"${mailcap}/etc/mime.types\"\,\n\t&,' src/mime/type_unix.go

    # Disabling the 'os/http/net' tests (they want files not available in
    # chroot builds)
    rm src/net/{listen,parse}_test.go
    rm src/syscall/exec_linux_test.go

    # !!! substituteInPlace does not seems to be effective.
    # The os test wants to read files in an existing path. Just don't let it be /usr/bin.
    sed -i 's,/usr/bin,'"`pwd`", src/os/os_test.go
    sed -i 's,/bin/pwd,'"`type -P pwd`", src/os/os_test.go
    # Fails on aarch64
    sed -i '/TestFallocate/aif true \{ return\; \}' src/cmd/link/internal/ld/fallocate_test.go
    # Skip this test since ssl patches mess it up.
    sed -i '/TestLoadSystemCertsLoadColonSeparatedDirs/aif true \{ return\; \}' src/crypto/x509/root_unix_test.go
    # Disable another PIE test which breaks.
    sed -i '/TestTrivialPIE/aif true \{ return\; \}' misc/cgo/testshared/shared_test.go
    # Disable the BuildModePie test
    sed -i '/TestBuildmodePIE/aif true \{ return\; \}' src/cmd/go/go_test.go
    # Disable the unix socket test
    sed -i '/TestShutdownUnix/aif true \{ return\; \}' src/net/net_test.go
    # Disable the hostname test
    sed -i '/TestHostname/aif true \{ return\; \}' src/os/os_test.go
    # ParseInLocation fails the test
    sed -i '/TestParseInSydney/aif true \{ return\; \}' src/time/format_test.go
    # Remove the api check as it never worked
    sed -i '/src\/cmd\/api\/run.go/ireturn nil' src/cmd/dist/test.go
    # Remove the coverage test as we have removed this utility
    sed -i '/TestCoverageWithCgo/aif true \{ return\; \}' src/cmd/go/go_test.go
    # Remove the timezone naming test
    sed -i '/TestLoadFixed/aif true \{ return\; \}' src/time/time_test.go
    # Remove disable setgid test
    sed -i '/TestRespectSetgidDir/aif true \{ return\; \}' src/cmd/go/internal/work/build_test.go
    # Remove cert tests that conflict with NixOS's cert resolution
    sed -i '/TestEnvVars/aif true \{ return\; \}' src/crypto/x509/root_unix_test.go
    # TestWritevError hangs sometimes
    sed -i '/TestWritevError/aif true \{ return\; \}' src/net/writev_test.go
    # TestVariousDeadlines fails sometimes
    sed -i '/TestVariousDeadlines/aif true \{ return\; \}' src/net/timeout_test.go

    sed -i 's,/etc/protocols,${iana-etc}/etc/protocols,' src/net/lookup_unix.go
    sed -i 's,/etc/services,${iana-etc}/etc/services,' src/net/port_unix.go

    # Disable cgo lookup tests not works, they depend on resolver
    rm src/net/cgo_unix_test.go

    # prepend the nix path to the zoneinfo files but also leave the original value for static binaries
    # that run outside a nix server
    sed -i 's,\"/usr/share/zoneinfo/,"${tzdata}/share/zoneinfo/\"\,\n\t&,' src/time/zoneinfo_unix.go

  '' + lib.optionalString stdenv.isAarch32 ''
    echo '#!${runtimeShell}' > misc/cgo/testplugin/test.bash
  '' + lib.optionalString stdenv.isDarwin ''
    substituteInPlace src/race.bash --replace \
      "sysctl machdep.cpu.extfeatures | grep -qv EM64T" true
    sed -i 's,strings.Contains(.*sysctl.*,true {,' src/cmd/dist/util.go
    sed -i 's,"/etc","'"$TMPDIR"'",' src/os/os_test.go
    sed -i 's,/_go_os_test,'"$TMPDIR"'/_go_os_test,' src/os/path_test.go

    sed -i '/TestChdirAndGetwd/aif true \{ return\; \}' src/os/os_test.go
    sed -i '/TestCredentialNoSetGroups/aif true \{ return\; \}' src/os/exec/exec_posix_test.go
    sed -i '/TestRead0/aif true \{ return\; \}' src/os/os_test.go
    sed -i '/TestSystemRoots/aif true \{ return\; \}' src/crypto/x509/root_darwin_test.go

    sed -i '/TestGoInstallRebuildsStalePackagesInOtherGOPATH/aif true \{ return\; \}' src/cmd/go/go_test.go
    sed -i '/TestBuildDashIInstallsDependencies/aif true \{ return\; \}' src/cmd/go/go_test.go

    sed -i '/TestDisasmExtld/aif true \{ return\; \}' src/cmd/objdump/objdump_test.go

    sed -i 's/unrecognized/unknown/' src/cmd/link/internal/ld/lib.go

    # TestCurrent fails because Current is not implemented on Darwin
    sed -i 's/TestCurrent/testCurrent/g' src/os/user/user_test.go
    sed -i 's/TestLookup/testLookup/g' src/os/user/user_test.go

    touch $TMPDIR/group $TMPDIR/hosts $TMPDIR/passwd
  '';

  patches = [
    ./remove-tools-1.11.patch
    ./ssl-cert-file-1.16.patch
    ./remove-test-pie-1.15.patch
    ./creds-test.patch
    ./skip-chown-tests-1.16.patch
    ./skip-external-network-tests-1.16.patch
    ./skip-nohup-tests.patch
    ./skip-cgo-tests-1.15.patch
    ./go_no_vendor_checks-1.16.patch
  ];

  postPatch = ''
    find . -name '*.orig' -exec rm {} ';'
  '';

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
  # Hopefully avoids test timeouts on Hydra
  GO_TEST_TIMEOUT_SCALE = 3;

  # Indicate that we are running on build infrastructure
  # Some tests assume things like home directories and users exists
  GO_BUILDER_NAME = "nix";

  GOROOT_BOOTSTRAP = "${goBootstrap}/share/go";

  postConfigure = ''
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
  '';

  postBuild = ''
    (cd src && ./make.bash)
  '';

  doCheck = stdenv.hostPlatform == stdenv.targetPlatform && !stdenv.isDarwin;

  checkPhase = ''
    runHook preCheck
    (cd src && HOME=$TMPDIR GOCACHE=$TMPDIR/go-cache ./run.bash --no-rebuild)
    runHook postCheck
  '';

  preInstall = ''
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
  '' else "");

  installPhase = ''
    runHook preInstall
    mkdir -p $GOROOT_FINAL
    cp -a bin pkg src lib misc api doc $GOROOT_FINAL
    ln -s $GOROOT_FINAL/bin $out/bin
    runHook postInstall
  '';

  disallowedReferences = [ goBootstrap ];

  meta = with lib; {
    homepage = "https://go.dev/";
    description = "The Go Programming language";
    license = licenses.bsd3;
    maintainers = teams.golang.members;
    platforms = platforms.linux ++ platforms.darwin;
  };
}
