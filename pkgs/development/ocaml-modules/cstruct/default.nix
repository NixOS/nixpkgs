{ stdenv, fetchzip, ocaml, findlib, sexplib, ocplib-endian, lwt, camlp4 }:

let version = "1.6.0"; in

stdenv.mkDerivation {
  name = "ocaml-cstruct-${version}";

  src = fetchzip {
    url = "https://github.com/mirage/ocaml-cstruct/archive/v${version}.tar.gz";
    sha256 = "09qw3rhfiq2kkns6660p9cwm5610k72md52a04cy91gr6gsig6ic";
  };

  buildInputs = [ ocaml findlib lwt camlp4 ];
  propagatedBuildInputs = [ ocplib-endian sexplib ];

  configureFlags = "--enable-lwt";

  createFindlibDestdir = true;

  meta = {
    description = "Map OCaml arrays onto C-like structs";
    homepage = https://github.com/mirage/ocaml-cstruct;
    license = stdenv.lib.licenses.isc;
    maintainers = with stdenv.lib.maintainers; [ vbgl ];
    platforms = ocaml.meta.platforms;
  };
}
