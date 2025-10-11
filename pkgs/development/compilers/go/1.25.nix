{
  lib,
  stdenv,
  fetchurl,
  tzdata,
  replaceVars,
  iana-etc,
  mailcap,
  buildPackages,
  pkgsBuildTarget,
  targetPackages,
  # for testing
  testers,
  runCommand,
  bintools,
  skopeo,
  clickhouse-backup,
  buildGo125Module,
}:

let
  goBootstrap = buildPackages.callPackage ./bootstrap122.nix { };

  skopeoTest = skopeo.override { buildGoModule = buildGo125Module; };
  clickhouse-backupTest = clickhouse-backup.override { buildGoModule = buildGo125Module; };

  # We need a target compiler which is still runnable at build time,
  # to handle the cross-building case where build != host == target
  targetCC = pkgsBuildTarget.targetPackages.stdenv.cc;

  isCross = stdenv.buildPlatform != stdenv.targetPlatform;

  # go-default-pie.patch tries to enable position-independent codegen (PIE) only when the platform
  # reports support (via BuildModeSupported(..., "pie", ...)).
  #
  # In order for buildmode=pie to work either Go's internal linker must know how
  # to produce position-independent executables or Go must be using an external linker.
  #
  # That probe is not fully reliable: for example, `pkgsi686Linux.go` can fail during bootstrap
  # with message 'default PIE binary requires external (cgo) linking, but cgo is not enabled'
  # despite CGO being enabled. (we set `CGO_ENABLED=1`).
  #
  # To avoid such breakage, limit this patch to a small set of explicitly tested platforms
  # rather than relying on the general BuildModeSupported("pie") check.
  supportsDefaultPie =
    let
      hasPie = {
        "amd64" = true;
        "arm64" = true;
        "ppc64le" = true;
        "riscv64" = true;
      };
    in
    hasPie.${stdenv.hostPlatform.go.GOARCH} or false
    && hasPie.${stdenv.targetPlatform.go.GOARCH} or false;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "go";
  version = "1.25.2";

  src = fetchurl {
    url = "https://go.dev/dl/go${finalAttrs.version}.src.tar.gz";
    hash = "sha256-NxEUDPuH/Oj3oT982GDfBB5sEvdhD0DKxuxvorZeluQ=";
  };

  strictDeps = true;
  buildInputs =
    [ ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [ stdenv.cc.libc.out ]
    ++ lib.optionals (stdenv.hostPlatform.libc == "glibc") [ stdenv.cc.libc.static ];

  depsBuildTarget = lib.optional isCross targetCC;

  depsTargetTarget = lib.optional stdenv.targetPlatform.isMinGW targetPackages.threads.package;

  postPatch = ''
    patchShebangs .
  '';

  patches = [
    (replaceVars ./iana-etc-1.25.patch {
      iana = iana-etc;
    })
    # Patch the mimetype database location which is missing on NixOS.
    # but also allow static binaries built with NixOS to run outside nix
    (replaceVars ./mailcap-1.17.patch {
      inherit mailcap;
    })
    # prepend the nix path to the zoneinfo files but also leave the original value for static binaries
    # that run outside a nix server
    (replaceVars ./tzdata-1.19.patch {
      inherit tzdata;
    })
    ./remove-tools-1.11.patch
    ./go_no_vendor_checks-1.23.patch
    ./go-env-go_ldso.patch
  ]
  ++ lib.optionals supportsDefaultPie [
    (replaceVars ./go-default-pie.patch {
      inherit (stdenv.targetPlatform.go) GOARCH;
    })
  ];

  inherit (stdenv.targetPlatform.go) GOOS GOARCH GOARM;
  # GOHOSTOS/GOHOSTARCH must match the building system, not the host system.
  # Go will nevertheless build a for host system that we will copy over in
  # the install phase.
  GOHOSTOS = stdenv.buildPlatform.go.GOOS;
  GOHOSTARCH = stdenv.buildPlatform.go.GOARCH;

  # {CC,CXX}_FOR_TARGET must be only set for cross compilation case as go expect those
  # to be different from CC/CXX
  CC_FOR_TARGET = if isCross then "${targetCC}/bin/${targetCC.targetPrefix}cc" else null;
  CXX_FOR_TARGET = if isCross then "${targetCC}/bin/${targetCC.targetPrefix}c++" else null;

  GO386 = "softfloat"; # from Arch: don't assume sse2 on i686
  # Wasi does not support CGO
  # ppc64/linux CGO is incomplete/borked, and will likely not receive any further improvements
  # https://github.com/golang/go/issues/8912
  # https://github.com/golang/go/issues/13192
  CGO_ENABLED =
    if
      (
        stdenv.targetPlatform.isWasi
        || (stdenv.targetPlatform.isPower64 && stdenv.targetPlatform.isBigEndian)
      )
    then
      0
    else
      1;

  GOROOT_BOOTSTRAP = "${goBootstrap}/share/go";

  buildPhase = ''
    runHook preBuild
    export GOCACHE=$TMPDIR/go-cache
    if [ -f "$NIX_CC/nix-support/dynamic-linker" ]; then
      export GO_LDSO=$(cat $NIX_CC/nix-support/dynamic-linker)
    fi

    export PATH=$(pwd)/bin:$PATH

    ${lib.optionalString isCross ''
      # Independent from host/target, CC should produce code for the building system.
      # We only set it when cross-compiling.
      export CC=${buildPackages.stdenv.cc}/bin/cc
      # Prefer external linker for cross when CGO is supported, since
      # we haven't taught go's internal linker to pick the correct ELF
      # interpreter for cross
      # When CGO is not supported we rely on static binaries being built
      # since they don't need an ELF interpreter
      export GO_EXTLINK_ENABLED=${toString finalAttrs.CGO_ENABLED}
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
  ''
  + (
    if (stdenv.buildPlatform.system != stdenv.hostPlatform.system) then
      ''
        mv bin/*_*/* bin
        rmdir bin/*_*
        ${lib.optionalString
          (!(finalAttrs.GOHOSTARCH == finalAttrs.GOARCH && finalAttrs.GOOS == finalAttrs.GOHOSTOS))
          ''
            rm -rf pkg/${finalAttrs.GOHOSTOS}_${finalAttrs.GOHOSTARCH} pkg/tool/${finalAttrs.GOHOSTOS}_${finalAttrs.GOHOSTARCH}
          ''
        }
      ''
    else
      lib.optionalString (stdenv.hostPlatform.system != stdenv.targetPlatform.system) ''
        rm -rf bin/*_*
        ${lib.optionalString
          (!(finalAttrs.GOHOSTARCH == finalAttrs.GOARCH && finalAttrs.GOOS == finalAttrs.GOHOSTOS))
          ''
            rm -rf pkg/${finalAttrs.GOOS}_${finalAttrs.GOARCH} pkg/tool/${finalAttrs.GOOS}_${finalAttrs.GOARCH}
          ''
        }
      ''
  );

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/go
    cp -a bin pkg src lib misc api doc go.env VERSION $out/share/go
    mkdir -p $out/bin
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
      # Picked clickhouse-backup as a package that sets CGO_ENABLED=0
      # Running and outputting the right version proves a working ELF interpreter was picked
      clickhouse-backup = testers.testVersion { package = clickhouse-backupTest; };
      clickhouse-backup-is-pie = runCommand "has-pie" { meta.broken = stdenv.hostPlatform.isStatic; } ''
        ${lib.optionalString (!isCross) ''
          if ${lib.getExe' bintools "readelf"} -p .comment ${lib.getExe clickhouse-backup} | grep -Fq "GCC: (GNU)"; then
            echo "${lib.getExe clickhouse-backup} has a GCC .comment, but it should have used the internal go linker"
            exit 1
          fi
        ''}
        if ${lib.getExe' bintools "readelf"} -h ${lib.getExe clickhouse-backup} | grep -q "Type:.*DYN"; then
          touch $out
        else
          echo "ERROR: clickhouse-backup is NOT PIE"
          exit 1
        fi
      '';
    };
  };

  meta = with lib; {
    changelog = "https://go.dev/doc/devel/release#go${lib.versions.majorMinor finalAttrs.version}";
    description = "Go Programming language";
    homepage = "https://go.dev/";
    license = licenses.bsd3;
    teams = [ teams.golang ];
    platforms = platforms.darwin ++ platforms.linux ++ platforms.wasi ++ platforms.freebsd;
    badPlatforms = [
      # Support for big-endian POWER < 8 was dropped in 1.9, but POWER8 users have less of a reason to run in big-endian mode than pre-POWER8 ones
      # So non-LE ppc64 is effectively unsupported, and Go SIGILLs on affordable ppc64 hardware
      # https://github.com/golang/go/issues/19074 - Dropped support for big-endian POWER < 8, with community pushback
      # https://github.com/golang/go/issues/73349 - upstream will not accept submissions to fix this
      "powerpc64-linux"
    ];
    mainProgram = "go";
  };
})
