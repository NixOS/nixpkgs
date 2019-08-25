{ stdenv, pkgconfig, ocaml, findlib, fetchurl, curl, ncurses }:

if stdenv.lib.versionOlder ocaml.version "4.02"
then throw "ocurl is not available for OCaml ${ocaml.version}"
else

stdenv.mkDerivation rec {
  name = "ocurl-0.8.2";
  src = fetchurl {
    url = "http://ygrek.org.ua/p/release/ocurl/${name}.tar.gz";
    sha256 = "1ax3xdlzgb1zg7d0wr9nwgmh6a45a764m0wk8p6mx07ad94hz0q9";
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
