{ stdenv, pkgconfig, ocaml, findlib, fetchurl, curl, ncurses }:

stdenv.mkDerivation rec {
  name = "ocurl-0.8.0";
  src = fetchurl {
    url = "http://ygrek.org.ua/p/release/ocurl/${name}.tar.gz";
    sha256 = "0292knvm9g038br0dc03lcsnbjqycyiqha256dp4bxkz3vmmz4wr";
  };

  buildInputs = [ pkgconfig ocaml findlib ncurses ];
  propagatedBuildInputs = [ curl ];
  createFindlibDestdir = true;
  meta = {
    description = "OCaml bindings to libcurl";
    license = stdenv.lib.licenses.mit;
    homepage = "http://ygrek.org.ua/p/ocurl/";
    maintainers = with stdenv.lib.maintainers; [ bennofs ];
    platforms = ocaml.meta.platforms or [];
  };
}
