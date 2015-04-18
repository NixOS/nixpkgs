{ stdenv, fetchurl, which, coq, flocq, mathcomp }:

stdenv.mkDerivation {
  name = "coq-interval-${coq.coq-version}-2.0.0";

  src = fetchurl {
    url = https://gforge.inria.fr/frs/download.php/file/34294/interval-2.0.0.tar.gz;
    sha256 = "0wx0z07nhx88hwl20icgb5w4mx6s5pn7mhzyx5jn8f7yl1m46ad2";
  };

  nativeBuildInputs = [ which ];
  buildInputs = [ coq ];
  propagatedBuildInputs = [ flocq mathcomp ];

  configurePhase = "./configure --libdir=$out/lib/coq/${coq.coq-version}/user-contrib/Interval";
  buildPhase = "./remake";
  installPhase = "./remake install";

  meta = with stdenv.lib; {
    homepage = http://coq-interval.gforge.inria.fr/;
    description = "Tactics for simplifying the proofs of inequalities on expressions of real numbers for the Coq proof assistant";
    license = licenses.cecill-c;
    maintainers = with maintainers; [ vbgl ];
    platforms = coq.meta.platforms;
  };
}
