{
  version,
  hash,
  patches,
}:

{
  buildPackages,
  cacert,
  cmake,
  curl,
  darwin,
  fetchurl,
  gfortran,
  gnum4,
  lib,
  libxml2,
  openssl,
  perl,
  python3,
  stdenv,
  unzip,
  which,
  xcbuild,
  zlib,
}:

stdenv.mkDerivation rec {
  pname = "julia";

  inherit version patches;

  src = fetchurl {
    url = "https://github.com/JuliaLang/julia/releases/download/v${version}/julia-${version}-full.tar.gz";
    inherit hash;
  };

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    gfortran
    gnum4
    openssl
    perl
    python3
    which
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    curl
    darwin.DarwinTools
    darwin.sigtool
    unzip
    xcbuild
  ];

  buildInputs = [
    libxml2
    zlib
  ]
  ++ lib.optionals (lib.versionAtLeast version "1.11") [
    cacert
  ];

  dontUseCmakeConfigure = true;

  postPatch = ''
    patchShebangs .
  ''
  + lib.optionalString (lib.versionAtLeast version "1.11") ''
    substituteInPlace deps/curl.mk \
      --replace-fail 'cd $(dir $<) && $(TAR) jxf $(notdir $<)' \
                     'cd $(dir $<) && $(TAR) jxf $(notdir $<) && sed -i "s|/usr/bin/env perl|${lib.getExe buildPackages.perl}|" curl-$(CURL_VER)/scripts/cd2nroff'
  ''
  + lib.optionalString (lib.versionOlder version "1.12") ''
    substituteInPlace deps/tools/common.mk \
      --replace-fail "CMAKE_COMMON := " "CMAKE_COMMON := ${lib.cmakeFeature "CMAKE_POLICY_VERSION_MINIMUM" "3.10"} "
  ''
  + lib.optionalString (lib.versionAtLeast version "1.12") ''
    substituteInPlace deps/openssl.mk \
      --replace-fail 'cd $(dir $<) && $(TAR) -zxf $<' \
                     'cd $(dir $<) && $(TAR) -zxf $< && sed -i "s|/usr/bin/env perl|${lib.getExe buildPackages.perl}|" openssl-$(OPENSSL_VER)/Configure'
  '';

  makeFlags = [
    "prefix=$(out)"
    "USE_BINARYBUILDER=0"
  ]
  ++ lib.optionals stdenv.hostPlatform.isx86_64 [
    # https://github.com/JuliaCI/julia-buildkite/blob/main/utilities/build_envs.sh
    "JULIA_CPU_TARGET=generic;sandybridge,-xsaveopt,clone_all;haswell,-rdrnd,base(1);x86-64-v4,-rdrnd,base(1)"
  ]
  ++ lib.optionals stdenv.hostPlatform.isAarch64 [
    "JULIA_CPU_TARGET=generic;cortex-a57;thunderx2t99;carmel,clone_all;apple-m1,base(3);neoverse-512tvb,base(3)"
    "USE_BINARYBUILDER=${if stdenv.hostPlatform.isDarwin then "1" else "0"}"
  ];

  # remove forbidden reference to $TMPDIR
  preFixup = lib.optionalString stdenv.hostPlatform.isElf ''
    for file in libcurl.so libgmpxx.so libmpfr.so; do
      patchelf --shrink-rpath --allowed-rpath-prefixes ${builtins.storeDir} "$out/lib/julia/$file"
    done
  '';

  # Code signing on version 1.9 is done as part of the build process, although
  # we need a patch because darwin.sigtool has a more limited set of arguments
  # than the modern macOS codesign utility.
  #
  # For the later versions, patching the same way doesn't seem to work, so we
  # re-sign in the postFixup.
  postFixup =
    lib.optionalString (lib.versionAtLeast version "1.10" && stdenv.hostPlatform.isDarwin)
      ''
        codesign -s - --force --entitlements ./contrib/mac/app/Entitlements.plist $out/bin/julia

        # We also need to re-sign the dylibs. Julia will be killed by macOS when you try to
        # start it without this line. This will output errors for some of the dylibs.
        find $out -name "*.dylib" -exec codesign -s - --force {} \;
      '';

  # tests are flaky for aarch64-linux on hydra
  # some tests not working on aarch64-darwin for unrelated reasons
  doInstallCheck =
    stdenv.hostPlatform.isLinux
    && (lib.versionAtLeast version "1.10" || !stdenv.hostPlatform.isAarch64);

  installCheckTarget = "testall";

  preInstallCheck = ''
    export JULIA_TEST_USE_MULTIPLE_WORKERS="true"
    # Some tests require read/write access to $HOME.
    # And $HOME cannot be equal to $TMPDIR as it causes test failures
    export HOME=$(mktemp -d)
  '';

  dontStrip = true;

  enableParallelBuilding = true;

  env = lib.optionalAttrs (lib.versionOlder version "1.11" || stdenv.hostPlatform.isAarch64) {
    NIX_CFLAGS_COMPILE = toString ([
      "-Wno-error=implicit-function-declaration"
      "-Wno-error=incompatible-pointer-types"
    ]);
  };

  meta = with lib; {
    description = "High-level performance-oriented dynamical language for technical computing";
    mainProgram = "julia";
    homepage = "https://julialang.org/";
    license = licenses.mit;
    maintainers = with maintainers; [
      nickcao
      joshniemela
      thomasjm
    ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "aarch64-darwin"
    ];
  };
}
