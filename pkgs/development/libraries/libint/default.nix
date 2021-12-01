{ lib, stdenv, fetchFromGitHub, autoconf, automake, libtool
, python3, perl, gmpxx, mpfr, boost, eigen, gfortran, cmake
, enableFMA ? stdenv.hostPlatform.fmaSupport
, enableFortran ? true
}:

let
  pname = "libint";
  version = "2.7.1";

  meta = with lib; {
    description = "Library for the evaluation of molecular integrals of many-body operators over Gaussian functions";
    homepage = "https://github.com/evaleev/libint";
    license = with licenses; [ lgpl3Only gpl3Only ];
    maintainers = with maintainers; [ markuskowa sheepforce ];
    platforms = [ "x86_64-linux" ];
  };

  codeGen = stdenv.mkDerivation {
    inherit pname version;

    src = fetchFromGitHub {
      owner = "evaleev";
      repo = pname;
      rev = "v${version}";
      sha256 = "5nSeyT1DhFsA76Dt3dqYfhfBYD+iTl34O3lVeH6+OVw=";
    };

    # Replace hardcoded "/bin/rm" with normal "rm"
    postPatch = ''
      for f in \
        bin/ltmain.sh \
        configure.ac \
        src/bin/libint/Makefile \
        src/lib/libint/Makefile.library \
        tests/eri/Makefile \
        tests/hartree-fock/Makefile \
        tests/unit/Makefile; do
          substituteInPlace $f --replace "/bin/rm" "rm"
      done
    '';

    nativeBuildInputs = [
      autoconf
      automake
      libtool
      mpfr
      python3
      perl
      gmpxx
    ] ++ lib.optional enableFortran gfortran;

    buildInputs = [ boost eigen ];

    preConfigure = "./autogen.sh";

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

    makeFlags = [ "export" ];

    installPhase = ''
      mkdir -p $out
      cp ${pname}-${version}.tgz $out/.
    '';

    enableParallelBuilding = true;

    inherit meta;
  };

  codeComp = stdenv.mkDerivation {
    inherit pname version;

    src = "${codeGen}/${pname}-${version}.tgz";

    nativeBuildInputs = [
      python3
      cmake
    ] ++ lib.optional enableFortran gfortran;

    buildInputs = [ boost eigen ];

    # Default is just "double", but SSE2 is available on all x86_64 CPUs.
    # AVX support is advertised, but does not work in 2.6 (possibly in 2.7).
    # Fortran interface is incompatible with changing the LIBINT2_REALTYPE.
    cmakeFlags = [
      (if enableFortran
        then "-DENABLE_FORTRAN=ON"
        else "-DLIBINT2_REALTYPE=libint2::simd::VectorSSEDouble"
      )
    ];

    # Can only build in the source-tree. A lot of preprocessing magic fails otherwise.
    dontUseCmakeBuildDir = true;

    inherit meta;
  };

in codeComp
