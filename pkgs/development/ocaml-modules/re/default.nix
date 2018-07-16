{ stdenv, fetchzip, ocaml, findlib, jbuilder, ounit }:

if !stdenv.lib.versionAtLeast ocaml.version "4.02"
then throw "re is not available for OCaml ${ocaml.version}"
else

stdenv.mkDerivation rec {
  name = "ocaml${ocaml.version}-re-${version}";
  version = "1.7.3";

  src = fetchzip {
    url = "https://github.com/ocaml/ocaml-re/archive/${version}.tar.gz";
    sha256 = "1pb6w9wqg6gzcfaaw6ckv1bqjgjpmrzzqz7r0mp9w16qbf3i54zr";
  };

  buildInputs = [ ocaml findlib jbuilder ounit ];

  doCheck = true;
  checkPhase = "jbuilder runtest";

  inherit (jbuilder) installPhase;

  meta = {
    homepage = https://github.com/ocaml/ocaml-re;
    platforms = ocaml.meta.platforms or [];
    description = "Pure OCaml regular expressions, with support for Perl and POSIX-style strings";
    license = stdenv.lib.licenses.lgpl2;
    maintainers = with stdenv.lib.maintainers; [ vbgl ];
  };
}
