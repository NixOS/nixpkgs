{ stdenv, fetchzip, fetchpatch, ocaml, findlib, ocamlbuild, ocaml_oasis, camlp4, uutf, markup, ppx_tools, re
}:

assert stdenv.lib.versionAtLeast ocaml.version "4.02";

stdenv.mkDerivation rec {
  pname = "tyxml";
  version = "4.0.1";
  name = "ocaml${ocaml.version}-${pname}-${version}";

  src = fetchzip {
    url = "http://github.com/ocsigen/tyxml/archive/${version}.tar.gz";
    sha256 = "1mwkjvl78gvw7pvql5qp64cfjjca6aqsb04999qkllifyicaaq8y";
  };

  patches = [ (fetchpatch {
    url = https://github.com/dbuenzli/tyxml/commit/a2bf5ccc0b6e684e7b81274ff19df8d72e2def8d.diff;
    sha256 = "11sidgiwz3zqw815vlslbfzb456z0lndkh425mlmvnmck4d2v2i3";
  })];

  buildInputs = [ ocaml findlib ocamlbuild camlp4 ];

  propagatedBuildInputs = [uutf re ppx_tools markup];

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
