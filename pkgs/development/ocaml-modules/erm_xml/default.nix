{ stdenv, fetchzip, ocaml, findlib, ocamlbuild }:

if !stdenv.lib.versionAtLeast ocaml.version "4.02"
then throw "erm_xml is not available for OCaml ${ocaml.version}"
else

let version = "0.3+20180112"; in

stdenv.mkDerivation {
  name = "ocaml${ocaml.version}-erm_xml-${version}";

  src = fetchzip {
    url = "https://github.com/hannesm/xml/archive/bbabdade807d8281fc48806da054b70dfe482479.tar.gz";
    sha256 = "1gawpmg8plip0wia0xq60m024dn7l3ykwbjpbqx9f9bdmx74n1rr";
  };

  buildInputs = [ ocaml findlib ocamlbuild ];

  createFindlibDestdir = true;

  meta = {
    homepage = "https://github.com/hannesm/xml";
    description = "XML Parser for discrete data";
    platforms = ocaml.meta.platforms or [];
    license = stdenv.lib.licenses.bsd3;
    maintainers = with stdenv.lib.maintainers; [ vbgl ];
  };
}
