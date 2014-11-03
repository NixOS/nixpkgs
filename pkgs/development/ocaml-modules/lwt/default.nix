{stdenv, fetchurl, which, cryptopp, ocaml, findlib, ocaml_react, ocaml_ssl, libev, pkgconfig, ncurses, ocaml_oasis, ocaml_text, glib, camlp4, ppx_tools }:

let
  version = "2.4.6";
in

stdenv.mkDerivation {
  name = "ocaml-lwt-${version}";

  src = fetchurl {
    url = "https://github.com/ocsigen/lwt/archive/${version}.tar.gz";
    sha256 = "1wczlr6akpr6i946p23b5v94brsywc0j724smrdqc0z64srwd44z";
  };

  buildInputs = [ocaml_oasis pkgconfig which cryptopp ocaml findlib glib libev ncurses camlp4 ppx_tools ];

  propagatedBuildInputs = [ ocaml_react ocaml_ssl ocaml_text ];

  #configureFlags = [ "--enable-all" ];

  createFindlibDestdir = true;

  meta = {
    homepage = http://ocsigen.org/lwt;
    description = "Lightweight thread library for Objective Caml";
    license = "LGPL";
    platforms = ocaml.meta.platforms;
    maintainers = [
      stdenv.lib.maintainers.z77z stdenv.lib.maintainers.gal_bolle
    ];
  };
}
