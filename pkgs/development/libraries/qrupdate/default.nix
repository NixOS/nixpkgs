{ stdenv
, fetchurl
, gfortran
, blas
, lapack
, which
}:

stdenv.mkDerivation rec {
  pname = "qrupdate";
  version = "1.1.2";
  src = fetchurl {
    url = "mirror://sourceforge/qrupdate/${pname}-${version}.tar.gz";
    sha256 = "024f601685phcm1pg8lhif3lpy5j9j0k6n0r46743g4fvh8wg8g2";
  };

  preBuild =
    # Check that blas and lapack are compatible
    assert (blas.isILP64 == lapack.isILP64);
  # We don't have structuredAttrs yet implemented, and we need to use space
  # seprated values in makeFlags, so only this works.
  ''
    makeFlagsArray+=(
      "LAPACK=-L${lapack}/lib -llapack"
      "BLAS=-L${blas}/lib -lblas"
      "PREFIX=${placeholder "out"}"
      ${stdenv.lib.optionalString blas.isILP64
      # Use their FFLAGS along with `-fdefault-integer-8`. If another
      # application intends to use arpack, it should add this to it's FFLAGS as
      # well. Otherwise (e.g): https://savannah.gnu.org/bugs/?50339
      "FFLAGS=-fimplicit-none -O3 -funroll-loops -fdefault-integer-8"
      }
    )
  '';

  doCheck = true;

  checkTarget = "test";

  buildFlags = [ "lib" "solib" ];

  installTargets = stdenv.lib.optionals stdenv.isDarwin [ "install-staticlib" "install-shlib" ];

  buildInputs = [ gfortran ];

  nativeBuildInputs = [ which ];

  meta = with stdenv.lib; {
    description = "Library for fast updating of qr and cholesky decompositions";
    homepage = "https://sourceforge.net/projects/qrupdate/";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ doronbehar ];
    platforms = platforms.unix;
  };
}
