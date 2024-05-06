{ stdenv, lib, fetchFromGitHub, expat, ocaml, findlib, ounit }:

lib.throwIfNot (lib.versionAtLeast ocaml.version "4.02")
  "ocaml_expat is not available for OCaml ${ocaml.version}"

stdenv.mkDerivation rec {
  pname = "ocaml${ocaml.version}-expat";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "whitequark";
    repo = "ocaml-expat";
    rev = "v${version}";
    hash = "sha256-eDA6MUcztaI+fpunWBdanNnPo9Y5gvbj/ViVcxYYEBg=";
  };

  prePatch = ''
    substituteInPlace Makefile --replace "gcc" "\$(CC)"
  '';

  nativeBuildInputs = [ ocaml findlib ];
  buildInputs = [ expat ];

  strictDeps = true;

  doCheck = lib.versionAtLeast ocaml.version "4.08";
  checkTarget = "testall";
  checkInputs = [ ounit ];

  createFindlibDestdir = true;

  meta = {
    description = "OCaml wrapper for the Expat XML parsing library";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.vbgl ];
    inherit (src.meta) homepage;
    inherit (ocaml.meta) platforms;
  };
}
