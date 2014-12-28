{stdenv, fetchgit, which, cryptopp, ocaml, findlib, ocaml_react, ocaml_ssl, libev, pkgconfig, ncurses, ocaml_oasis, ocaml_text, glib, camlp4}:

let
  version = "2.4.5";
  inherit (stdenv.lib) optional getVersion versionAtLeast;
  ocaml_version = getVersion ocaml;
in

stdenv.mkDerivation {


  name = "ocaml-lwt-${version}";

  src = fetchgit {
    url = git://github.com/ocsigen/lwt;
    rev = "refs/tags/${version}";
    sha256 = "2bbf4f216dd62eeb765a89413f3b2b6d417a9c289ca49d595bb4d7a0545e343e";
  };

  buildInputs = [ocaml_oasis pkgconfig which cryptopp ocaml findlib glib libev ncurses camlp4];

  propagatedBuildInputs = [ ocaml_react ocaml_ssl ocaml_text ];

  configureFlags = [ "--enable-react" "--enable-glib" "--enable-ssl" "--enable-text" ]
  ++ optional (versionAtLeast ocaml_version "4.0" && ! versionAtLeast ocaml_version "4.02") "--enable-toplevel";

  createFindlibDestdir = true;

  meta = with stdenv.lib; {
    homepage = http://ocsigen.org/lwt;
    description = "Lightweight thread library for Objective Caml";
    license = licenses.lgpl21;
    platforms = ocaml.meta.platforms;
    maintainers = with maintainers; [
      z77z vbgl gal_bolle
    ];
  };
}
