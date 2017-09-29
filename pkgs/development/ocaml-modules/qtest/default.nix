{ stdenv, fetchzip, ocaml, findlib, ocamlbuild, qcheck, ounit }:

if !stdenv.lib.versionAtLeast ocaml.version "4"
then throw "qtest is not available for OCaml ${ocaml.version}"
else

let version = "2.6"; in

stdenv.mkDerivation {
  name = "ocaml-qtest-${version}";
  src = fetchzip {
    url = "https://github.com/vincent-hugot/iTeML/archive/v${version}.tar.gz";
    sha256 = "1v5c1n5p8rhnisn606fs05q8764lqwgw08w66y5dm8wgmxgmsb3k";
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
