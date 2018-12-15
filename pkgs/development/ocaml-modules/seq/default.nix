{ stdenv, fetchFromGitHub, ocaml, findlib, ocamlbuild }:

stdenv.mkDerivation rec {
  version = "0.1";
  name = "ocaml${ocaml.version}-seq-${version}";

  src = fetchFromGitHub {
    owner = "c-cube";
    repo = "seq";
    rev = version;
    sha256 = "1cjpsc7q76yfgq9iyvswxgic4kfq2vcqdlmxjdjgd4lx87zvcwrv";
  };

  buildInputs = [ ocaml findlib ocamlbuild ];

  createFindlibDestdir = true;

  meta = {
    description = "Compatibility package for OCaml’s standard iterator type starting from 4.07";
    license = stdenv.lib.licenses.lgpl21;
    maintainers = [ stdenv.lib.maintainers.vbgl ];
    inherit (src.meta) homepage;
    inherit (ocaml.meta) platforms;
  };
}
