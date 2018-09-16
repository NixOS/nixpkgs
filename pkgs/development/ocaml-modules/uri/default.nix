{ stdenv, fetchurl, ocaml, findlib, dune, ppx_sexp_conv, ounit
, re, sexplib, stringext
}:

stdenv.mkDerivation rec {
  version = "1.9.6";
  name = "ocaml${ocaml.version}-uri-${version}";

  src = fetchurl {
    url = "https://github.com/mirage/ocaml-uri/releases/download/v${version}/uri-${version}.tbz";
    sha256 = "1m845rwd70wi4iijkrigyz939m1x84ba70hvv0d9sgk6971w4kz0";
  };

  unpackCmd = "tar -xjf $curSrc";

  buildInputs = [ ocaml findlib dune ounit ];
  propagatedBuildInputs = [ ppx_sexp_conv re sexplib stringext ];

  buildPhase = "jbuilder build";

  doCheck = true;
  checkPhase = "jbuilder runtest";

  inherit (dune) installPhase;

  meta = {
    homepage = "https://github.com/mirage/ocaml-uri";
    description = "RFC3986 URI parsing library for OCaml";
    license = stdenv.lib.licenses.isc;
    maintainers = [ stdenv.lib.maintainers.vbgl ];
    inherit (ocaml.meta) platforms;
  };
}
