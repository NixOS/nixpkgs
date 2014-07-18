{stdenv, fetchgit, which, cryptopp, ocaml, findlib, ocaml_react, ocaml_ssl, libev, pkgconfig, ncurses, ocaml_oasis, ocaml_text, glib}:

let
  version = "2.4.5";
in

stdenv.mkDerivation {


  name = "ocaml-lwt-${version}";

  src = fetchgit {
    url = git://github.com/ocsigen/lwt;
    rev = "refs/tags/${version}";
    sha256 = "2bbf4f216dd62eeb765a89413f3b2b6d417a9c289ca49d595bb4d7a0545e343e";
  };

  buildInputs = [ocaml_oasis pkgconfig which cryptopp ocaml findlib glib libev ncurses];

  propagatedBuildInputs = [ ocaml_react ocaml_ssl ocaml_text ];

  configureFlags = [ "--enable-all" ];

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
