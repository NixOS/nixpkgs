{ stdenv, fetchzip, ocaml, findlib, ocamlbuild, jsonm, hex, sexplib, lwt }:

let version = "0.4.3"; in

stdenv.mkDerivation {
  name = "ocaml-ezjsonm-${version}";

  src = fetchzip {
    url = "https://github.com/mirage/ezjsonm/archive/${version}.tar.gz";
    sha256 = "1y6p3ga6vj1wx5dyns7hjgd0qgrrn2hnn323a7y5didgci5pybls";
  };

  buildInputs = [ ocaml findlib ocamlbuild lwt ];
  propagatedBuildInputs = [ jsonm hex sexplib ];
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
