{stdenv, fetchurl, coq}:

stdenv.mkDerivation {

  name = "coq-containers-${coq.coq-version}";

  src = fetchurl {
    url = http://coq.inria.fr/pylons/contribs/files/Containers/v8.4/Containers.tar.gz;
    sha256 = "0z7yk0g7zkniwc73ka7wwb5jjg5a2wr1krrn3akr7kn5z3gvy2mc";
  };

  buildInputs = [ coq.ocaml coq.camlp5 ];
  propagatedBuildInputs = [ coq ];

  installFlags = "COQLIB=$(out)/lib/coq/${coq.coq-version}/";

  meta = with stdenv.lib; {
    homepage = http://coq.inria.fr/pylons/pylons/contribs/view/Containers/v8.4;
    description = "A typeclass-based Coq library of finite sets/maps";
    maintainers = with maintainers; [ vbgl jwiegley ];
    platforms = coq.meta.platforms;
  };

}
