{ stdenv
, fetchurl
, gfortran
, blas
, lapack
}:
stdenv.mkDerivation {
  name = "qrupdate-1.1.2";
  src = fetchurl {
    url = "mirror://sourceforge/qrupdate/qrupdate-1.1.2.tar.gz";
    sha256 = "024f601685phcm1pg8lhif3lpy5j9j0k6n0r46743g4fvh8wg8g2";
  };

  configurePhase =
    ''
      export PREFIX=$out
      sed -i -e 's,^BLAS=.*,BLAS=-L${blas}/lib -lblas,' \
          -e 's,^LAPACK=.*,LAPACK=-L${lapack}/lib -llapack,' \
          Makeconf
    ''
    + stdenv.lib.optionalString blas.isILP64
    ''
      sed -i Makeconf -e '/^FFLAGS=.*/ s/$/-fdefault-integer-8/'
    '';

  doCheck = true;

  checkTarget = "test";

  buildFlags = [ "lib" "solib" ];

  installTargets = stdenv.lib.optionals stdenv.isDarwin [ "install-staticlib" "install-shlib" ];

  buildInputs = [ gfortran blas lapack ];

  meta = with stdenv.lib; {
    description = "Library for fast updating of qr and cholesky decompositions";
    homepage = "https://sourceforge.net/projects/qrupdate/";
    license = licenses.gpl3;
    platforms = platforms.unix;
  };
}
