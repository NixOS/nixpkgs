{ stdenv
, fetchurl
, gfortran
, openblas
}:
stdenv.mkDerivation {
  name = "qrupdate-1.1.2";
  src = fetchurl {
    url = mirror://sourceforge/qrupdate/qrupdate-1.1.2.tar.gz ;
    sha256 = "024f601685phcm1pg8lhif3lpy5j9j0k6n0r46743g4fvh8wg8g2";
  };

  configurePhase =
    ''
      export PREFIX=$out
      sed -i -e 's,^BLAS=.*,BLAS=-L${openblas}/lib -lopenblas,' \
          -e 's,^LAPACK=.*,LAPACK=-L${openblas}/lib -lopenblas,' \
          Makeconf
    ''
    + stdenv.lib.optionalString openblas.blas64
    ''
      sed -i Makeconf -e '/^FFLAGS=.*/ s/$/-fdefault-integer-8/'
    '';

  doCheck = true;

  checkTarget = "test";

  buildFlags = [ "lib" "solib" ];

  installTargets = if stdenv.isDarwin
                   then ["install-staticlib" "install-shlib"]
                   else "install";

  buildInputs = [ gfortran openblas ];

  meta = {
    platforms = stdenv.lib.platforms.unix;
  };
}
