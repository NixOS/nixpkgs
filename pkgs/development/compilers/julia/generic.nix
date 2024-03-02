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
    homepage = "https://julialang.org/";
    license = licenses.mit;
    maintainers = with maintainers; [ nickcao joshniemela thomasjm ];
    platforms = [ "x86_64-linux" "aarch64-linux" ];
  };
}
