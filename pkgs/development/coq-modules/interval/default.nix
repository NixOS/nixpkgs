{ stdenv, fetchurl, which, coq, coquelicot, flocq, mathcomp
, bignums ? null }:

stdenv.mkDerivation {
  name = "coq${coq.coq-version}-interval-3.3.0";

  src = fetchurl {
    url = "https://gforge.inria.fr/frs/download.php/file/37077/interval-3.3.0.tar.gz";
    sha256 = "08fdcf3hbwqphglvwprvqzgkg0qbimpyhnqsgv3gac4y1ap0f903";
  };

  nativeBuildInputs = [ which ];
  buildInputs = [ coq ];
  propagatedBuildInputs = [ bignums coquelicot flocq mathcomp ];

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

  passthru = { inherit (mathcomp) compatibleCoqVersions; };

}
