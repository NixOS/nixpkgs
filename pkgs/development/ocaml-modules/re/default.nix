{ stdenv, fetchzip, ocaml, findlib, dune, ounit, seq }:

if !stdenv.lib.versionAtLeast ocaml.version "4.02"
then throw "re is not available for OCaml ${ocaml.version}"
else

stdenv.mkDerivation rec {
  name = "ocaml${ocaml.version}-re-${version}";
  version = "1.8.0";

  src = fetchzip {
    url = "https://github.com/ocaml/ocaml-re/archive/${version}.tar.gz";
    sha256 = "0ch6hvmm4ym3w2vghjxf3ka5j1023a37980fqi4zcb7sx756z20i";
  };

  buildInputs = [ ocaml findlib dune ounit ];
  propagatedBuildInputs = [ seq ];

  doCheck = true;
  checkPhase = "jbuilder runtest";

  inherit (dune) installPhase;

  meta = {
    homepage = https://github.com/ocaml/ocaml-re;
    platforms = ocaml.meta.platforms or [];
    description = "Pure OCaml regular expressions, with support for Perl and POSIX-style strings";
    license = stdenv.lib.licenses.lgpl2;
    maintainers = with stdenv.lib.maintainers; [ vbgl ];
  };
}
