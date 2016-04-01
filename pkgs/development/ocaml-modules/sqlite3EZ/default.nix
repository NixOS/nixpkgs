{stdenv, fetchurl, ocaml, findlib, twt, ocaml_sqlite3 }:

assert stdenv.lib.versionAtLeast (stdenv.lib.getVersion ocaml) "3.12";

stdenv.mkDerivation {
  name = "ocaml-sqlite3EZ-0.1.0";

  src = fetchurl {
    url = https://github.com/mlin/ocaml-sqlite3EZ/archive/v0.1.0.tar.gz;
    sha256 = "8ed2c5d5914a65cbd95589ef11bfb8b38a020eb850cdd49b8adce7ee3a563748";
  };

  buildInputs = [ ocaml findlib twt ];

  propagatedBuildInputs = [ ocaml_sqlite3 ];

  createFindlibDestdir = true;

  meta = with stdenv.lib; {
    homepage = http://github.com/mlin/ocaml-sqlite3EZ;
    description = "A thin wrapper for sqlite3-ocaml with a simplified interface";
    license = licenses.mit;
    maintainers = [ maintainers.vbgl ];
    platforms = ocaml.meta.platforms or [];
  };
}
