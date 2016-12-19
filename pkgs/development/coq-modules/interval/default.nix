{ stdenv, fetchurl, which, coq, coquelicot, flocq, mathcomp }:

stdenv.mkDerivation {
  name = "coq-interval-${coq.coq-version}-2.2.1";

  src = fetchurl {
    url = https://gforge.inria.fr/frs/download.php/file/35431/interval-2.2.1.tar.gz;
    sha256 = "1i6v7da9mf6907sa803xa0llsf9lj4akxbrl8rma6gsdgff2d78n";
  };

  nativeBuildInputs = [ which ];
  buildInputs = [ coq ];
  propagatedBuildInputs = [ coquelicot flocq mathcomp ];

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
