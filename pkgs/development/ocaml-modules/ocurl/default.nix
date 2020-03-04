{ stdenv, pkgconfig, ocaml, findlib, fetchurl, curl, ncurses }:

if stdenv.lib.versionOlder ocaml.version "4.02"
then throw "ocurl is not available for OCaml ${ocaml.version}"
else

stdenv.mkDerivation rec {
  name = "ocurl-0.9.0";
  src = fetchurl {
    url = "http://ygrek.org.ua/p/release/ocurl/${name}.tar.gz";
    sha256 = "0v5qzfazaynjv1xy3ds2z5iz0np5mz8g831l91l1mrqz6fr1ah0f";
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
