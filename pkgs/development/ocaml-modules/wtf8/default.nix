{ stdenv, fetchurl, ocaml, findlib, dune }:

assert stdenv.lib.versionAtLeast (stdenv.lib.getVersion ocaml) "4.01";

stdenv.mkDerivation rec {
  pname = "wtf8";
  name = "ocaml-${pname}-${version}";
  version = "1.0.1";

  src = fetchurl {
    url = "https://github.com/flowtype/ocaml-${pname}/releases/download/v${version}/${pname}-${version}.tbz";
    sha256 = "1msg3vycd3k8qqj61sc23qks541cxpb97vrnrvrhjnqxsqnh6ygq";
  };

  unpackCmd = "tar xjf $src";

  buildInputs = [ ocaml findlib dune ];

  buildPhase = "dune build -p wtf8";

  inherit (dune) installPhase;

  meta = with stdenv.lib; {
    homepage = https://github.com/flowtype/ocaml-wtf8;
    description = "WTF-8 is a superset of UTF-8 that allows unpaired surrogates.";
    license = licenses.mit;
    platforms = ocaml.meta.platforms or [];
    maintainers = [ maintainers.eqyiel ];
  };
}
