{ stdenv, fetchzip, ocaml, findlib }:

let version = "0.3"; in

stdenv.mkDerivation {
  name = "ocaml-erm_xml-${version}";

  src = fetchzip {
    url = "https://github.com/ermine/xml/archive/v${version}.tar.gz";
    sha256 = "19znk5w0qiw3wij4n6w3h5bcr221yy57jf815fr8k9m8kin710g3";
  };

  buildInputs = [ ocaml findlib ];

  createFindlibDestdir = true;

  meta = {
    homepage = https://github.com/ermine/xml;
    description = "XML Parser for discrete data";
    platforms = ocaml.meta.platforms or [];
    license = stdenv.lib.licenses.bsd3;
    maintainers = with stdenv.lib.maintainers; [ vbgl ];
  };
}
