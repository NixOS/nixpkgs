{ stdenv, fetchzip, ocaml, findlib, ocamlbuild, ounit }:

if !stdenv.lib.versionAtLeast ocaml.version "4"
then throw "qtest is not available for OCaml ${ocaml.version}"
else

let version = "2.2"; in

stdenv.mkDerivation {
  name = "ocaml-qtest-${version}";
  src = fetchzip {
    url = "https://github.com/vincent-hugot/iTeML/archive/v${version}.tar.gz";
    sha256 = "1k68z8kby1f9s5j9xbn9bz8yhk59aalffz8gj5d1y5zhyalifrlz";
  };

  buildInputs = [ ocaml findlib ocamlbuild ];
  propagatedBuildInputs = [ ounit ];

  createFindlibDestdir = true;
  installFlags = [ "BIN=$(out)/bin" ];
  preInstall = "mkdir -p $out/bin";

  meta = {
    description = "Inline (Unit) Tests for OCaml (formerly “qtest”)";
    homepage = https://github.com/vincent-hugot/iTeML;
    platforms = ocaml.meta.platforms or [];
    maintainers = with stdenv.lib.maintainers; [ vbgl ];
  };
}
