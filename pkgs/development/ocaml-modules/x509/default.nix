{ stdenv, fetchurl, ocaml, findlib, ocamlbuild, topkg
, asn1-combinators, astring, nocrypto, ppx_sexp_conv
, ounit, cstruct-unix
}:

stdenv.mkDerivation rec {
  name = "ocaml${ocaml.version}-x509-${version}";
  version = "0.6.0";

  src = fetchurl {
    url = "https://github.com/mirleft/ocaml-x509/releases/download/${version}/x509-${version}.tbz";
    sha256 = "0pmi3s4179bpy4076fmrhwv500wp9x1nrglsj9kk0xc8s8vadc7x";
  };

  unpackCmd = "tar -xjf $curSrc";

  buildInputs = [ ocaml findlib ocamlbuild topkg ppx_sexp_conv ounit cstruct-unix ];
  propagatedBuildInputs = [ asn1-combinators astring nocrypto ];

  buildPhase = "${topkg.run} build --tests true";

  doCheck = true;
  checkPhase = "${topkg.run} test";

  inherit (topkg) installPhase;

  meta = with stdenv.lib; {
    homepage = https://github.com/mirleft/ocaml-x509;
    description = "X509 (RFC5280) handling in OCaml";
    license = licenses.bsd2;
    maintainers = with maintainers; [ vbgl ];
  };
}
