{stdenv, fetchsvn, coq}:

stdenv.mkDerivation {

  name = "coq-tlc-${coq.coq-version}";

  src = fetchsvn {
    url = svn://scm.gforge.inria.fr/svn/tlc/branches/v3.1;
    rev = 240;
    sha256 = "0mjnb6n9wzb13y2ix9cvd6irzd9d2gj8dcm2x71wgan0jcskxadm";
  };

  buildInputs = [ coq.ocaml coq.camlp5 ];
  propagatedBuildInputs = [ coq ];

  installPhase = ''
    COQLIB=$out/lib/coq/${coq.coq-version}/
    mkdir -p $COQLIB/user-contrib/Tlc
    cp -p *.vo $COQLIB/user-contrib/Tlc
  '';

  meta = with stdenv.lib; {
    homepage = http://www.chargueraud.org/softs/tlc/;
    description = "TLC is a general purpose Coq library that provides an alternative to Coq's standard library";
    maintainers = with maintainers; [ jwiegley ];
    platforms = coq.meta.platforms;
  };

}
