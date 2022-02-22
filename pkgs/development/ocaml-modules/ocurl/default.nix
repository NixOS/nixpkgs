{ stdenv, lib, pkg-config, ocaml, findlib, fetchurl, curl, ncurses, lwt }:

if lib.versionOlder ocaml.version "4.02"
then throw "ocurl is not available for OCaml ${ocaml.version}"
else

stdenv.mkDerivation rec {
  pname = "ocurl";
  version = "0.9.2";

  src = fetchurl {
    url = "http://ygrek.org.ua/p/release/ocurl/ocurl-${version}.tar.gz";
    sha256 = "sha256-4DWXGMh02s1VwLWW5d7h0jtMOUubWmBPGm1hghfWd2M=";
  };

  buildInputs = [ pkg-config ocaml findlib ncurses ];
  propagatedBuildInputs = [ curl lwt ];
  createFindlibDestdir = true;
  meta = {
    description = "OCaml bindings to libcurl";
    license = lib.licenses.mit;
    homepage = "http://ygrek.org.ua/p/ocurl/";
    maintainers = with lib.maintainers; [ bennofs ];
    platforms = ocaml.meta.platforms or [ ];
  };
}
