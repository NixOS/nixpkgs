{stdenv, fetchdarcs, coq}:

stdenv.mkDerivation rec {

  name = "coq-domains-${coq.coq-version}-${version}";
  version = "ce1a9806";

  src = fetchdarcs {
    url = http://hub.darcs.net/rdockins/domains;
    context = ./darcs_context;
    sha256 = "0zdqiw08b453i8gdxwbk7nia2dv2r3pncmxsvgr0kva7f3dn1rnc";
  };

  buildInputs = [ coq.ocaml coq.camlp5 ];
  propagatedBuildInputs = [ coq ];

  installFlags = "COQLIB=$(out)/lib/coq/${coq.coq-version}/";

  meta = with stdenv.lib; {
    homepage = http://rwd.rdockins.name/domains/;
    description = "A Coq library for domain theory";
    maintainers = with maintainers; [ jwiegley ];
    platforms = coq.meta.platforms;
  };

}
