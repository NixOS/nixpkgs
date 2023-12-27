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
}:

stdenv.mkDerivation rec {
  pname = "julia";
  version = "1.9.4";

  src = fetchurl {
    url = "https://github.com/JuliaLang/julia/releases/download/v${version}/julia-${version}-full.tar.gz";
    hash = "sha256-YYQ7lkf9BtOymU8yd6ZN4ctaWlKX2TC4yOO8DpN0ACQ=";
  };

  patches = [
    ./patches/1.8/0002-skip-failing-and-flaky-tests.patch
  ];

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
  ];

  dontUseCmakeConfigure = true;

  postPatch = ''
    patchShebangs .
  '';

  makeFlags = [
    "prefix=$(out)"
    "USE_BINARYBUILDER=0"
  ] ++ lib.optionals stdenv.isx86_64 [
    # https://github.com/JuliaCI/julia-buildbot/blob/master/master/inventory.py
    "JULIA_CPU_TARGET=generic;sandybridge,-xsaveopt,clone_all;haswell,-rdrnd,base(1)"
  ] ++ lib.optionals stdenv.isAarch64 [
    "JULIA_CPU_TARGET=generic;cortex-a57;thunderx2t99;armv8.2-a,crypto,fullfp16,lse,rdm"
  ];

  # remove forbidden reference to $TMPDIR
  preFixup = ''
    for file in libcurl.so libgmpxx.so libmpfr.so; do
      patchelf --shrink-rpath --allowed-rpath-prefixes ${builtins.storeDir} "$out/lib/julia/$file"
    done
  '';

  doInstallCheck = !stdenv.hostPlatform.isAarch64; # tests are flaky for aarch64-linux on hydra
  installCheckTarget = "testall";

  preInstallCheck = ''
    export HOME="$TMPDIR"
    export JULIA_TEST_USE_MULTIPLE_WORKERS="true"
  '';

  dontStrip = true;

  enableParallelBuilding = true;

  meta = with lib; {
    description = "High-level performance-oriented dynamical language for technical computing";
    homepage = "https://julialang.org/";
    license = licenses.mit;
    maintainers = with maintainers; [ nickcao joshniemela thomasjm ];
    platforms = [ "x86_64-linux" "aarch64-linux" ];
  };
}
