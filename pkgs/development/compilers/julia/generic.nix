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
, zlib
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
  ];

  buildInputs = [
    libxml2
    zlib
  ];

  dontUseCmakeConfigure = true;

  postPatch = ''
    patchShebangs .
  '';

  makeFlags = [
    "prefix=$(out)"
    "USE_BINARYBUILDER=0"
  ] ++ lib.optionals stdenv.hostPlatform.isx86_64 [
    # https://github.com/JuliaCI/julia-buildkite/blob/main/utilities/build_envs.sh
    "JULIA_CPU_TARGET=generic;sandybridge,-xsaveopt,clone_all;haswell,-rdrnd,base(1);x86-64-v4,-rdrnd,base(1)"
  ] ++ lib.optionals stdenv.hostPlatform.isAarch64 [
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

  installCheckTarget = "testall";

  preInstallCheck = ''
    export JULIA_TEST_USE_MULTIPLE_WORKERS="true"
    # Some tests require read/write access to $HOME.
    # And $HOME cannot be equal to $TMPDIR as it causes test failures
    export HOME=$(mktemp -d)
  '';

  dontStrip = true;

  enableParallelBuilding = true;

  meta = with lib; {
    description = "High-level performance-oriented dynamical language for technical computing";
    mainProgram = "julia";
    homepage = "https://julialang.org/";
    license = licenses.mit;
    maintainers = with maintainers; [ nickcao joshniemela thomasjm ];
    platforms = [ "x86_64-linux" "aarch64-linux" ];
  };
}
