{ stdenv, fetchFromGitHub, which, ocaml, findlib, ocamlbuild, decompress }:

stdenv.mkDerivation rec {
  version = "20171028";
  name = "ocaml${ocaml.version}-imagelib-${version}";
  src = fetchFromGitHub {
    owner = "rlepigre";
    repo = "ocaml-imagelib";
    rev = "ocaml-imagelib_${version}";
    sha256 = "1frkrgcrv4ybdmqcfxpfsywx0hm1arxgxp32n8kzky6qip1g0zxf";
  };

  buildInputs = [ which ocaml findlib ocamlbuild ];

  propagatedBuildInputs = [ decompress ];

  createFindlibDestdir = true;

  meta = {
    description = "Image formats such as PNG and PPM in OCaml";
    license = stdenv.lib.licenses.lgpl3;
    maintainers = [ stdenv.lib.maintainers.vbgl ];
    inherit (src.meta) homepage;
    inherit (ocaml.meta) platforms;
  };
}
