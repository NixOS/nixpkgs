{
  lib,
  stdenv,
  apple-sdk_15,
  tzdata,
  replaceVars,
  iana-etc,
  mailcap,
  buildPackages,
  pkgsBuildTarget,
  targetPackages,
  testers,
  skopeo,
  buildGoModule,
  bootstrap,
  version,
  src,
}:

let
  skopeoTest = skopeo.override { inherit buildGoModule; };

  # We need a target compiler which is still runnable at build time,
  # to handle the cross-building case where build != host == target
  targetCC = pkgsBuildTarget.targetPackages.stdenv.cc;

  isCross = stdenv.buildPlatform != stdenv.targetPlatform;
in
stdenv.mkDerivation (finalAttrs: {
  inherit version src;
  pname = "go";

  strictDeps = true;
  buildInputs =
    [ ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [ stdenv.cc.libc.out ]
    ++ lib.optionals (stdenv.hostPlatform.libc == "glibc") [ stdenv.cc.libc.static ];

  depsTargetTargetPropagated =
    lib.optionals (stdenv.targetPlatform.isDarwin && lib.versions.minor version >= "25")
      [
        apple-sdk_15
      ];

  depsBuildTarget = lib.optional isCross targetCC;

  depsTargetTarget = lib.optional stdenv.targetPlatform.isMinGW targetPackages.threads.package;

  postPatch = ''
    patchShebangs .
  '';

  patches = [
    # These are always added since every version we have is 1.17+
    ./remove-tools-1.11.patch
    # Patch the mimetype database location which is missing on NixOS.
    # but also allow static binaries built with NixOS to run outside nix
    (replaceVars ./mailcap-1.17.patch {
      inherit mailcap;
    })
  ]

  # prepend the nix path to the zoneinfo files but also leave the original value for static binaries
  # that run outside a nix server
  # Only applied on 1.19+
  ++ lib.optional (lib.versions.minor version >= "19") (
    replaceVars ./tzdata-1.19.patch {
      inherit tzdata;
    }
  )
  # Only applied on 1.23+
  ++ lib.optional (lib.versions.minor version >= "23") ./go_no_vendor_checks-1.23.patch
  # Only applied on 1.25+
  ++ lib.optional (lib.versions.minor version >= "25") (
    replaceVars ./iana-etc-1.25.patch {
      iana = iana-etc;
    }
  )
  # Should only be applied below 1.25, as it has a corresponding 1.25+ patch above.
  ++ lib.optional (lib.versions.minor version < "25") (
    replaceVars ./iana-etc-1.17.patch {
      iana = iana-etc;
    }
  );

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
  CGO_ENABLED = if stdenv.targetPlatform.isWasi then 0 else 1;

  # GCC Bootstraps fail with /share/go appended because the path does not exist.
  GOROOT_BOOTSTRAP =
    if (bootstrap.meta.mainProgram == "gccgo") then "${bootstrap}/" else "${bootstrap}/share/go";

  buildPhase = ''
    runHook preBuild
    export GOCACHE=$TMPDIR/go-cache

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
    cp -a bin pkg src lib misc api doc VERSION $out/share/go
    # The go.env file was introduced with 1.21, so don't try to copy it on earlier versions
    ${lib.optionalString (lib.versions.minor version >= "21") "cp -a go.env $out/share/go"}

    mkdir -p $out/bin
    ln -s $out/share/go/bin/* $out/bin
    runHook postInstall
  '';

  disallowedReferences = [ bootstrap ];

  passthru = {
    inherit bootstrap skopeoTest;
    tests = {
      version = testers.testVersion {
        package = finalAttrs.finalPackage;
        command = "go version";
        version = "go${finalAttrs.version}";
      };
    }
    # Skopeo has a minimum version of 1.23.3, so we only run the test
    # with versions higher than that.
    // lib.optionalAttrs (lib.versions.minor version >= "23") {
      skopeo = testers.testVersion { package = skopeoTest; };
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
