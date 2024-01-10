{ lib
, stdenv
, fetchurl
, which
, python3
, gfortran
, cmake
, perl
, gnum4
, libxml2
, openssl
}:

stdenv.mkDerivation rec {
  pname = "julia";
  version = "1.8.5";

  src = fetchurl {
    url = "https://github.com/JuliaLang/julia/releases/download/v${version}/julia-${version}-full.tar.gz";
    hash = "sha256-NVVAgKS0085S7yICVDBr1CrA2I7/nrhVkqV9BmPbXfI=";
  };

  patches = [
    ./patches/1.8/0001-skip-building-doc.patch
    ./patches/1.8/0002-skip-failing-and-flaky-tests.patch
  ];

  nativeBuildInputs = [
    which
    python3
    gfortran
    cmake
    perl
    gnum4
  ];

  buildInputs = [
    libxml2
    openssl
  ];

  dontUseCmakeConfigure = true;

  postPatch = ''
    patchShebangs .
  '';

  makeFlags = [
    "prefix=$(out)"
    "USE_BINARYBUILDER=0"
    # workaround for https://github.com/JuliaLang/julia/issues/47989
    "USE_INTEL_JITEVENTS=0"
  ] ++ lib.optionals stdenv.isx86_64 [
    # https://github.com/JuliaCI/julia-buildbot/blob/master/master/inventory.py
    "JULIA_CPU_TARGET=generic;sandybridge,-xsaveopt,clone_all;haswell,-rdrnd,base(1)"
  ] ++ lib.optionals stdenv.isAarch64 [
    "JULIA_CPU_TARGET=generic;cortex-a57;thunderx2t99;armv8.2-a,crypto,fullfp16,lse,rdm"
  ];

  # remove forbidden reference to $TMPDIR
  preFixup = ''
    for file in libcurl.so libgmpxx.so; do
      patchelf --shrink-rpath --allowed-rpath-prefixes ${builtins.storeDir} "$out/lib/julia/$file"
    done
  '';

  doInstallCheck = true;
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
    maintainers = with maintainers; [ nickcao thomasjm ];
    platforms = [ "x86_64-linux" "aarch64-linux" ];
  };
}
