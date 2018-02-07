{ stdenv, fetchzip, ocaml, findlib, ocamlbuild, qcheck, ounit }:

if !stdenv.lib.versionAtLeast ocaml.version "4"
then throw "qtest is not available for OCaml ${ocaml.version}"
else

let version = "2.7"; in

stdenv.mkDerivation {
  name = "ocaml${ocaml.version}-qtest-${version}";
  src = fetchzip {
    url = "https://github.com/vincent-hugot/iTeML/archive/v${version}.tar.gz";
    sha256 = "0z72m2drp67qchvsxx4sg2qjrrq8hp6p9kzdx16ibx58pvpw1sh2";
  };

  buildInputs = [ ocaml findlib ocamlbuild ];
  propagatedBuildInputs = [ qcheck ounit ];

  installFlags = [ "BIN=$(out)/bin" ];
  preInstall = "mkdir -p $out/bin";

  meta = {
    description = "Inline (Unit) Tests for OCaml (formerly “qtest”)";
    homepage = https://github.com/vincent-hugot/iTeML;
    platforms = ocaml.meta.platforms or [];
    maintainers = with stdenv.lib.maintainers; [ vbgl ];
  };
}
