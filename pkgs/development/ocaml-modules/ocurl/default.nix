{ stdenv, pkgconfig, ocaml, findlib, fetchurl, curl, ncurses }:

if stdenv.lib.versionOlder ocaml.version "4.02"
then throw "ocurl is not available for OCaml ${ocaml.version}"
else

stdenv.mkDerivation rec {
  name = "ocurl-0.9.1";
  src = fetchurl {
    url = "http://ygrek.org.ua/p/release/ocurl/${name}.tar.gz";
    sha256 = "0n621cxb9012pj280c7821qqsdhypj8qy9qgrah79dkh6a8h2py6";
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
