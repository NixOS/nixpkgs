{ stdenv, ocaml, findlib, fetchurl, curl, ncurses }:

stdenv.mkDerivation rec {
  name = "ocurl-0.7.2";
  src = fetchurl {
    url = "https://forge.ocamlcore.org/frs/download.php/1463/${name}.tar.gz";
    sha256 = "0yn7f3g5wva8nqxh76adpq9rihggc405jkqysfghzwnf3yymyqrr";
  };

  buildInputs = [ocaml findlib curl ncurses];
  createFindlibDestdir = true;
  meta = {
    description = "OCaml bindings to libcurl";
    license = stdenv.lib.licenses.bsd3;
    homepage = http://ocurl.forge.ocamlcore.org/;
    maintainers = with stdenv.lib.maintainers; [ bennofs ];
    platforms = ocaml.meta.platforms;
  };
}
