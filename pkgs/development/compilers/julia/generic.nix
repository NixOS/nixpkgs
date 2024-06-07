{ version
, hash
, patches
}:

{ lib
, stdenv
, fetchurl
, which
, python3
, gfortran
, cmake
, perl
, gnum4
, openssl
, libxml2
, unzip
, curl
, xcbuild
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
    which
    python3
    gfortran
    cmake
    perl
    gnum4
    openssl
  ] ++ lib.optionals stdenv.isDarwin [
    unzip
    curl
    xcbuild
  ];

  buildInputs = [
    libxml2
  ];

  dontUseCmakeConfigure = true;

  postPatch = ''
    patchShebangs .
  '';

  makeFlags = [
    "prefix=$(out)"
  ] ++ lib.optionals stdenv.isDarwin [
    # TODO: figure out how to build deps on darwin
    "USE_BINARYBUILDER=1"
  ] ++ lib.optionals (!stdenv.isDarwin) [
    "USE_BINARYBUILDER=0"
  ] ++ lib.optionals stdenv.isx86_64 [
    # https://github.com/JuliaCI/julia-buildkite/blob/main/utilities/build_envs.sh
    "JULIA_CPU_TARGET=generic;sandybridge,-xsaveopt,clone_all;haswell,-rdrnd,base(1);x64-64-v4,-rdrnd,base(1)"
  ] ++ lib.optionals stdenv.isAarch64 [
    "JULIA_CPU_TARGET=generic;cortex-a57;thunderx2t99;carmel,clone_all;apple-m1,base(3);neoverse-512tvb,base(3)"
  ];

  NIX_CFLAGS_COMPILE = [] ++ lib.optionals stdenv.isDarwin [
    "-Wno-error=implicit-function-declaration"
    "-Wno-error=elaborated-enum-base"
  ];
  # TODO: figure out how to re-enable these as errors?

  # remove forbidden reference to $TMPDIR
  preFixup = ''
  ''
  + lib.optionalString stdenv.isLinux (''
    for file in libcurl.so libgmpxx.so libmpfr.so; do
      patchelf --shrink-rpath --allowed-rpath-prefixes ${builtins.storeDir} "$out/lib/julia/$file"
    done
  '');

  # tests are flaky for aarch64-linux on hydra
  # some tests not working on aarch64-darwin for unrelated reasons
  doInstallCheck = if (lib.versionOlder version "1.10") then (stdenv.isLinux && !stdenv.hostPlatform.isAarch64) else stdenv.isLinux;

  installCheckTarget = "testall";

  preInstallCheck = ''
    export JULIA_SSL_CA_ROOTS_PATH=""
    export JULIA_TEST_USE_MULTIPLE_WORKERS="true"
    # Some tests require read/write access to $HOME.
    # And $HOME cannot be equal to $TMPDIR as it causes test failures
    export HOME=$(mktemp -d)
  '';

  dontStrip = true;

  enableParallelBuilding = true;

  preInstall = ''
    export JULIA_SSL_CA_ROOTS_PATH=""
  '';

  meta = with lib; {
    description = "High-level performance-oriented dynamical language for technical computing";
    mainProgram = "julia";
    homepage = "https://julialang.org/";
    license = licenses.mit;
    maintainers = with maintainers; [ nickcao joshniemela thomasjm ];
    platforms = [ "x86_64-linux" "aarch64-linux" "aarch64-darwin" ];
  };
}
