{ stdenv, fetchzip, ocaml, findlib, ocamlbuild, camlp4, uutf, markup, ppx_tools_versioned, re
}:

assert stdenv.lib.versionAtLeast ocaml.version "4.02";

stdenv.mkDerivation rec {
  pname = "tyxml";
  version = "4.2.0";
  name = "ocaml${ocaml.version}-${pname}-${version}";

  src = fetchzip {
    url = "http://github.com/ocsigen/tyxml/archive/${version}.tar.gz";
    sha256 = "1zrkrmxyj5a2cdh4b9zr9anwfk320wv3x0ynxnyxl5za2ix8sld8";
  };

  buildInputs = [ ocaml findlib ocamlbuild camlp4 ppx_tools_versioned markup ];

  propagatedBuildInputs = [ uutf re ];

  createFindlibDestdir = true;

  configureFlags = "--enable-syntax";

  meta = with stdenv.lib; {
    homepage = http://ocsigen.org/tyxml/;
    description = "A library that makes it almost impossible for your OCaml programs to generate wrong XML output, using static typing";
    license = licenses.lgpl21;
    platforms = ocaml.meta.platforms or [];
    maintainers = with maintainers; [
      gal_bolle vbgl
      ];
  };

}
