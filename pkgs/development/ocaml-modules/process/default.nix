{ stdenv, lib, fetchFromGitHub, ocaml, findlib, ocamlbuild }:

stdenv.mkDerivation rec {
  pname = "ocaml${ocaml.version}-process";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "dsheets";
    repo = "ocaml-process";
    rev = version;
    sha256 = "0m1ldah5r9gcq09d9jh8lhvr77910dygx5m309k1jm60ah9mdcab";
  };

  nativeBuildInputs = [ ocaml findlib ocamlbuild ];
  strictDeps = true;

  createFindlibDestdir = true;

  meta = {
    description = "Easy process control in OCaml";
    license = lib.licenses.isc;
    maintainers = [ lib.maintainers.vbgl ];
    inherit (src.meta) homepage;
    inherit (ocaml.meta) platforms;
  };
}
