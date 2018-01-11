{ stdenv, fetchurl, ocaml, findlib, jbuilder, ppx_sexp_conv, ounit
, ppx_deriving, re, sexplib, stringext
}:

stdenv.mkDerivation rec {
  version = "1.9.5";
  name = "ocaml${ocaml.version}-uri-${version}";

  src = fetchurl {
    url = "https://github.com/mirage/ocaml-uri/releases/download/v${version}/uri-${version}.tbz";
    sha256 = "11cix26fisjbzd1kj12a78wjf3bfgaxpj8nz88bl3dssdakhswyc";
  };

  unpackCmd = "tar -xjf $curSrc";

  buildInputs = [ ocaml findlib jbuilder ppx_sexp_conv ounit ];
  propagatedBuildInputs = [ ppx_deriving re sexplib stringext ];

  buildPhase = "jbuilder build";

  doCheck = true;
  checkPhase = "jbuilder runtest";

  inherit (jbuilder) installPhase;

  meta = {
    homepage = "https://github.com/mirage/ocaml-uri";
    description = "RFC3986 URI parsing library for OCaml";
    license = stdenv.lib.licenses.isc;
    maintainers = [ stdenv.lib.maintainers.vbgl ];
    inherit (ocaml.meta) platforms;
  };
}
