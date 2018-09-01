{ stdenv, fetchzip, ocaml, findlib, ocamlbuild }:

if stdenv.lib.versionAtLeast ocaml.version "4.06"
then throw "erm_xml is not available for OCaml ${ocaml.version}"
else

let version = "0.3"; in

stdenv.mkDerivation {
  name = "ocaml-erm_xml-${version}";

  src = fetchzip {
    url = "https://github.com/ermine/xml/archive/v${version}.tar.gz";
    sha256 = "19znk5w0qiw3wij4n6w3h5bcr221yy57jf815fr8k9m8kin710g3";
  };

  buildInputs = [ ocaml findlib ocamlbuild ];

  createFindlibDestdir = true;

  meta = {
    homepage = https://github.com/ermine/xml;
    description = "XML Parser for discrete data";
    platforms = ocaml.meta.platforms or [];
    license = stdenv.lib.licenses.bsd3;
    maintainers = with stdenv.lib.maintainers; [ vbgl ];
  };
}
