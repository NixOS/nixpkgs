{ stdenv, fetchurl, ocaml, findlib, ocaml_oasis, camlp4, uutf, markup, ppx_tools, re }:

stdenv.mkDerivation rec {
  pname = "tyxml";
  version = "3.6.0";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "http://github.com/ocsigen/tyxml/archive/${version}.tar.gz";
    sha256 = "1rz0f48x8p1m30723rn5v85pp7rd0spr04sd7gzryy99vn3ianga";
    };

  buildInputs = [ocaml findlib camlp4];

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
