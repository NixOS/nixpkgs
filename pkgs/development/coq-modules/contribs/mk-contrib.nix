{ name, sha256, override }:

{ stdenv, fetchzip, coq }:

let
  self = {

  name = "coq-contribs-${name}-${coq.coq-version}";

  src = fetchzip {
    url = "http://www.lix.polytechnique.fr/coq/pylons/contribs/files/${name}/v${coq.coq-version}/${name}.tar.gz";
    inherit sha256;
  };

  buildInputs = [ coq.ocaml coq.camlp5 ];
  propagatedBuildInputs = [ coq ];

  installFlags = "COQLIB=$(out)/lib/coq/${coq.coq-version}/";

  meta = with stdenv.lib; {
    homepage = "http://www.lix.polytechnique.fr/coq/pylons/contribs/view/${name}/v${coq.coq-version}";
    maintainers = with maintainers; [ vbgl ];
    platforms = coq.meta.platforms;
  };

};

in

stdenv.mkDerivation (self // override self)
