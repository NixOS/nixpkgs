{ lib, stdenv, fetchurl, ocaml, findlib, ocamlbuild, twt, ocaml_sqlite3 }:

assert lib.versionAtLeast (lib.getVersion ocaml) "3.12";

if lib.versionAtLeast ocaml.version "4.06"
then throw "sqlite3EZ is not available for OCaml ${ocaml.version}"
else

stdenv.mkDerivation {
  name = "ocaml-sqlite3EZ-0.1.0";

  src = fetchurl {
    url = "https://github.com/mlin/ocaml-sqlite3EZ/archive/v0.1.0.tar.gz";
    sha256 = "8ed2c5d5914a65cbd95589ef11bfb8b38a020eb850cdd49b8adce7ee3a563748";
  };

  buildInputs = [ ocaml findlib ocamlbuild twt ];

  propagatedBuildInputs = [ ocaml_sqlite3 ];

  createFindlibDestdir = true;

  meta = with lib; {
    homepage = "https://github.com/mlin/ocaml-sqlite3EZ";
    description = "A thin wrapper for sqlite3-ocaml with a simplified interface";
    license = licenses.mit;
    maintainers = [ maintainers.vbgl ];
    platforms = ocaml.meta.platforms or [];
  };
}
