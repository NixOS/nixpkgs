{stdenv, fetchurl, coq}:

stdenv.mkDerivation {

  name = "coq-containers-${coq.coq-version}";

  src = fetchurl {
    url = http://coq.inria.fr/pylons/contribs/files/Containers/v8.4/Containers.tar.gz;
    sha256 = "1y9x2lwrskv2231z9ac3kv4bmg6h1415xpp4gl7v5w90ba6p6w8w";
  };

  buildInputs = [ coq.ocaml coq.camlp5 ];
  propagatedBuildInputs = [ coq ];

  installFlags = "COQLIB=$(out)/lib/coq/${coq.coq-version}/";

  meta = with stdenv.lib; {
    homepage = http://coq.inria.fr/pylons/pylons/contribs/view/Containers/v8.4;
    description = "A typeclass-based Coq library of finite sets/maps";
    maintainers = with maintainers; [ vbgl ];
    platforms = coq.meta.platforms;
  };

}
