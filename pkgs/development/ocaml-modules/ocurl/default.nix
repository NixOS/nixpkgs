{ stdenv, pkgconfig, ocaml, findlib, fetchurl, curl, ncurses }:

stdenv.mkDerivation rec {
  name = "ocurl-0.8.1";
  src = fetchurl {
    url = "http://ygrek.org.ua/p/release/ocurl/${name}.tar.gz";
    sha256 = "08ldzbx1k3mbjc01fmzsn86ll4paf331bcjss6iig6y6hgc9q3ry";
  };

  buildInputs = [ pkgconfig ocaml findlib ncurses ];
  propagatedBuildInputs = [ curl ];
  createFindlibDestdir = true;
  meta = {
    description = "OCaml bindings to libcurl";
    license = stdenv.lib.licenses.mit;
    homepage = http://ygrek.org.ua/p/ocurl/;
    maintainers = with stdenv.lib.maintainers; [ bennofs ];
    platforms = ocaml.meta.platforms or [];
  };
}
