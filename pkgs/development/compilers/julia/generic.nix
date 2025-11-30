{
  version,
  hash,
  patches ? [ ],
}:

{
  lib,
  stdenv,
  fetchurl,
  which,
  python3,
  gfortran,
  cacert,
  cmake,
  perl,
  gnum4,
  openssl,
  libxml2,
  zlib,
  buildPackages,
}:

let
  skip_tests = [
    # test flaky on ofborg
    "channels"
    # test flaky
    "read"
    "NetworkOptions"
    "REPL"
    "ccall"
  ]
  ++ lib.optionals (lib.versionAtLeast version "1.11") [
    "loading"
    "cmdlineargs"
  ]
  ++ lib.optionals (lib.versionAtLeast version "1.12") [
    "Distributed"
    # test flaky because of our RPATH patching
    # https://github.com/NixOS/nixpkgs/pull/230965#issuecomment-1545336489
    "Compiler/codegen"
    "precompile"
    "compileall"
  ]
  ++ lib.optionals (lib.versionOlder version "1.12") [
    "compiler/codegen" # older versions' test was in lowercase
  ];
in

stdenv.mkDerivation rec {
  pname = "julia";

  inherit version patches;

  src = fetchurl {
    url = "https://github.com/JuliaLang/julia/releases/download/v${version}/julia-${version}-full.tar.gz";
    inherit hash;
  };

  strictDeps = true;

  nativeBuildInputs = [
    which
    python3
    gfortran
    cmake
    perl
    gnum4
    openssl
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
  ];

  # remove forbidden reference to $TMPDIR
  preFixup = ''
    for file in libcurl.so libgmpxx.so libmpfr.so; do
      patchelf --shrink-rpath --allowed-rpath-prefixes ${builtins.storeDir} "$out/lib/julia/$file"
    done
  '';

  # tests are flaky for aarch64-linux on hydra
  doInstallCheck = if (lib.versionOlder version "1.10") then !stdenv.hostPlatform.isAarch64 else true;

  preInstallCheck = ''
    export JULIA_TEST_USE_MULTIPLE_WORKERS="true"
    # Some tests require read/write access to $HOME.
    # And $HOME cannot be equal to $TMPDIR as it causes test failures
    export HOME=$(mktemp -d)
  '';

  installCheckPhase = ''
    runHook preInstallCheck
    # Command lifted from `test/Makefile`.
    $out/bin/julia \
      --check-bounds=yes \
      --startup-file=no \
      --depwarn=error \
      $out/share/julia/test/runtests.jl \
      --skip internet_required ${toString skip_tests}
    runHook postInstallCheck
  '';

  dontStrip = true;

  enableParallelBuilding = true;

  env = lib.optionalAttrs (lib.versionOlder version "1.11" || stdenv.hostPlatform.isAarch64) {
    NIX_CFLAGS_COMPILE = toString [
      "-Wno-error=implicit-function-declaration"
      "-Wno-error=incompatible-pointer-types"
    ];
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
      taranarmo
    ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
  };
}
