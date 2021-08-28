{ lib
, stdenv
, fetchurl
, mpfr
, mpdecimal
, gmp
}:

let
  sharedExt = stdenv.hostPlatform.extensions.sharedLibrary;
in

stdenv.mkDerivation rec {
  pname = "libbf";
  # this format is used by everyone on repology, so let's adopt it
  version = "2020.01.19";

  src = fetchurl {
    url = "https://bellard.org/libbf/libbf-${lib.replaceStrings [ "." ] [ "-" ] version}.tar.gz";
    sha256 = "12g5jbb5xc7ysvis6bh1sxaydbsna8103m4khvrn66yli129m7f6";
  };

  # * delete all default CONFIG_* variables since they are checked using `ifdef`
  # * delete CC= setting since Makefile ignores $CC from the environment
  postPatch = ''
    sed -i -e '/^CONFIG_[0-9A-Z]\+=/d' \
      -e '/^CC=/d' \
      Makefile
  '';

  # uses x86 assembler
  doCheck = stdenv.hostPlatform.isx86;
  checkInputs = [
    mpfr
    mpdecimal
    gmp
  ];
  checkFlags = [
    "CONFIG_BFTEST=y"
  ];
  checkTarget = "test";

  makeFlags = lib.optionals stdenv.hostPlatform.avx2Support [
    "CONFIG_AVX2=y"
  ];

  postBuild =
    if stdenv.hostPlatform.isStatic then ''
       $AR rc libbf.a libbf.o cutils.o
       $RANLIB libbf.a
    '' else ''
       $CC -o libbf${sharedExt} -shared libbf.o cutils.o
    '';

  outputs = [ "out" "dev" ];

  installPhase = ''
    runHook preInstall
    install -Dm755 -t "$out/lib" libbf${
      if stdenv.hostPlatform.isStatic then ".a" else sharedExt
    }
    install -Dm644 -t "$dev/include" libbf.h
    # choose not to install tinypi executable or the benchmark
    runHook postInstall
  '';

  meta = {
    description = "Small library to handle arbitrary precision floating point numbers";
    license = lib.licenses.mit;
    homepage = "https://bellard.org/libbf/";
    maintainers = [ lib.maintainers.sternenseemann ];
    platforms = lib.platforms.all;
  };
}
