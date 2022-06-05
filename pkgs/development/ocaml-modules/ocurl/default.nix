{ stdenv, lib, pkg-config, ocaml, findlib, fetchurl, curl, ncurses, lwt }:

if lib.versionOlder ocaml.version "4.02"
then throw "ocurl is not available for OCaml ${ocaml.version}"
else

stdenv.mkDerivation rec {
  pname = "ocurl";
  version = "0.9.1";

  src = fetchurl {
    url = "http://ygrek.org.ua/p/release/ocurl/ocurl-${version}.tar.gz";
    sha256 = "0n621cxb9012pj280c7821qqsdhypj8qy9qgrah79dkh6a8h2py6";
  };

  nativeBuildInputs = [ pkg-config ocaml findlib ];
  buildInputs = [ ncurses ];
  propagatedBuildInputs = [ curl lwt ];

  strictDeps = true;

  createFindlibDestdir = true;
  meta = {
    description = "OCaml bindings to libcurl";
    license = lib.licenses.mit;
    homepage = "http://ygrek.org.ua/p/ocurl/";
    maintainers = with lib.maintainers; [ bennofs ];
    platforms = ocaml.meta.platforms or [ ];
  };
}
