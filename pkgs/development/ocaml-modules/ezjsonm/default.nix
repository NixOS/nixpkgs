{ stdenv, fetchzip, ocaml, findlib, jsonm, hex, sexplib, lwt }:

let version = "0.4.1"; in

stdenv.mkDerivation {
  name = "ocaml-ezjsonm-${version}";

  src = fetchzip {
    url = "https://github.com/mirage/ezjsonm/archive/${version}.tar.gz";
    sha256 = "0cfjh8awajvw6kkmxr65dvri4k6h29pynxvk76a8c2lkixpsc095";
  };

  buildInputs = [ ocaml findlib ];
  propagatedBuildInputs = [ jsonm hex sexplib lwt ];
  createFindlibDestdir = true;

  configureFlags = "--enable-lwt";

  meta = {
    description = "An easy interface on top of the Jsonm library";
    homepage = https://github.com/mirage/ezjsonm;
    license = stdenv.lib.licenses.isc;
    maintainers = with stdenv.lib.maintainers; [ vbgl ];
    platforms = ocaml.meta.platforms or [];
  };
}
