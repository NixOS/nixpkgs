{ stdenv, lib, fetchFromGitHub, autoreconfHook, which, ocaml, findlib }:

if lib.versionOlder ocaml.version "4.02"
then throw "bitv is not available for OCaml ${ocaml.version}"
else

stdenv.mkDerivation rec {
  pname = "ocaml${ocaml.version}-bitv";
  version = "1.3";

  src = fetchFromGitHub {
    owner = "backtracking";
    repo = "bitv";
    rev = version;
    sha256 = "sha256-sZwq6c10hBBS9tGvKlWD9GE3JBrZPByfDrXE6xIPcG4=";
  };

  nativeBuildInputs = [ autoreconfHook which ocaml findlib ];

  strictDeps = true;

  createFindlibDestdir = true;

  meta = {
    description = "A bit vector library for OCaml";
    license = lib.licenses.lgpl21;
    homepage = "https://github.com/backtracking/bitv";
    maintainers = [ lib.maintainers.vbgl ];
    inherit (ocaml.meta) platforms;
  };
}
