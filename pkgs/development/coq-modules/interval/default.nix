{ stdenv, fetchurl, which, coq, flocq, mathcomp }:

stdenv.mkDerivation {
  name = "coq-interval-${coq.coq-version}-2.1.0";

  src = fetchurl {
    url = https://gforge.inria.fr/frs/download.php/file/35092/interval-2.1.0.tar.gz;
    sha256 = "02sn8mh85kxwn7681h2z6r7vnac9idh4ik3hbmr2yvixizakb70b";
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
