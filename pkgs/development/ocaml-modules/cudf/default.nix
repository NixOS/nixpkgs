{ stdenv, fetchurl, ocaml, ocamlbuild, findlib, ocaml_extlib, perl }:

stdenv.mkDerivation rec {
  pname = "cudf";
  version = "0.9";

  src = fetchurl {
    url = "https://gforge.inria.fr/frs/download.php/36602/cudf-0.9.tar.gz";
    sha256 = "0771lwljqwwn3cryl0plny5a5dyyrj4z6bw66ha5n8yfbpcy8clr";
  };

  buildInputs = [
    ocaml
    ocamlbuild
    findlib
    ocaml_extlib
    perl
  ];

  makeFlags = [
    "OCAMLLIBDIR=$(out)/lib"
    "BINDIR=$(out)/bin"
    "LIBDIR=$(out)/lib"
    "INCDIR=$(out)/include"
  ];

  createFindlibDestdir = true;

  meta = {
    description = "CUDF (for Common Upgradeability Description Format) is a format for describing upgrade scenarios in package-based Free and Open Source Software distribution.";
    license = stdenv.lib.licenses.lgpl3;
    homepage = "http://www.mancoosi.org/cudf/";
  };
}
