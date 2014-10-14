{stdenv, fetchurl, coq, unzip}:

stdenv.mkDerivation rec {

  name = "coq-paco-${coq.coq-version}-${version}";
  version = "1.2.7";

  src = fetchurl {
    url = "http://plv.mpi-sws.org/paco/paco-${version}.zip";
    sha256 = "010fs74c0cmb9sz5dmrgzg4pmb2mgwia4gm0g9l7j2fq5xxcschb";
  };

  buildInputs = [ coq.ocaml coq.camlp5 unzip ];
  propagatedBuildInputs = [ coq ];

  preBuild = "cd src";

  installPhase = ''
    COQLIB=$out/lib/coq/${coq.coq-version}/
    mkdir -p $COQLIB/user-contrib/Paco
    cp -pR *.vo $COQLIB/user-contrib/Paco
  '';

  meta = with stdenv.lib; {
    homepage = http://plv.mpi-sws.org/paco/;
    description = "Paco is a Coq library implementing parameterized coinduction";
    maintainers = with maintainers; [ jwiegley ];
    platforms = coq.meta.platforms;
  };

}
