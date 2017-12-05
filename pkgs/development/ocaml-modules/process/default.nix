{ stdenv, fetchFromGitHub, ocaml, findlib, ocamlbuild }:

stdenv.mkDerivation rec {
  name = "ocaml${ocaml.version}-process-${version}";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "dsheets";
    repo = "ocaml-process";
    rev = version;
    sha256 = "0m1ldah5r9gcq09d9jh8lhvr77910dygx5m309k1jm60ah9mdcab";
  };

  buildInputs = [ ocaml findlib ocamlbuild ];

  createFindlibDestdir = true;

  meta = {
    description = "Easy process control in OCaml";
    license = stdenv.lib.licenses.isc;
    maintainers = [ stdenv.lib.maintainers.vbgl ];
    inherit (src.meta) homepage;
    inherit (ocaml.meta) platforms;
  };
}
