{ lib, stdenv, fetchFromGitHub, autoconf, automake, libtool
, python3, perl, gmpxx, mpfr, boost, eigen, gfortran
, enableFMA ? false
}:

stdenv.mkDerivation rec {
  pname = "libint2";
  version = "2.6.0";

  src = fetchFromGitHub {
    owner = "evaleev";
    repo = "libint";
    rev = "v${version}";
    sha256 = "0pbc2j928jyffhdp4x5bkw68mqmx610qqhnb223vdzr0n2yj5y19";
  };

  patches = [
    ./fix-paths.patch
  ];

  nativeBuildInputs = [
    autoconf
    automake
    libtool
    gfortran
    mpfr
    python3
    perl
    gmpxx
  ];

  buildInputs = [ boost ];

  enableParallelBuilding = true;

  doCheck = true;

  configureFlags = [
    "--enable-eri=2"
    "--enable-eri3=2"
    "--enable-eri2=2"
    "--with-eri-max-am=7,5,4"
    "--with-eri-opt-am=3"
    "--with-eri3-max-am=7"
    "--with-eri2-max-am=7"
    "--with-g12-max-am=5"
    "--with-g12-opt-am=3"
    "--with-g12dkh-max-am=5"
    "--with-g12dkh-opt-am=3"
    "--enable-contracted-ints"
    "--enable-shared"
   ] ++ lib.optional enableFMA "--enable-fma";

  preConfigure = ''
    ./autogen.sh
  '';

  postBuild = ''
    # build the fortran interface file
    cd export/fortran
    make libint_f.o ENABLE_FORTRAN=yes
    cd ../..
  '';

  postInstall = ''
    cp export/fortran/libint_f.mod $out/include/
  '';

  meta = with lib; {
    description = "Library for the evaluation of molecular integrals of many-body operators over Gaussian functions";
    homepage = "https://github.com/evaleev/libint";
    license = with licenses; [ lgpl3Only gpl3Only ];
    maintainers = [ maintainers.markuskowa ];
    platforms = [ "x86_64-linux" ];
  };
}
