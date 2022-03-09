{ stdenv, lib, fetchFromGitHub, expat, ocaml, findlib, ounit }:

stdenv.mkDerivation rec {
  pname = "ocaml${ocaml.version}-expat";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "whitequark";
    repo = "ocaml-expat";
    rev = "v${version}";
    sha256 = "07wm9663z744ya6z2lhiz5hbmc76kkipg04j9vw9dqpd1y1f2x3q";
  };

  prePatch = ''
    substituteInPlace Makefile --replace "gcc" "\$(CC)"
  '';

  nativeBuildInputs = [ ocaml findlib ];
  buildInputs = [ expat ounit ];

  strictDeps = true;

  doCheck = !lib.versionAtLeast ocaml.version "4.06";
  checkTarget = "testall";

  createFindlibDestdir = true;

  meta = {
    description = "OCaml wrapper for the Expat XML parsing library";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.vbgl ];
    inherit (src.meta) homepage;
    inherit (ocaml.meta) platforms;
  };
}
