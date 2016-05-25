{ stdenv, fetchzip, which, cryptopp, ocaml, findlib, ocaml_react, ocaml_ssl, libev, pkgconfig, ncurses, ocaml_oasis, ocaml_text, glib, camlp4, ppx_tools }:

let
  version = "2.5.2";
  inherit (stdenv.lib) optional getVersion versionAtLeast;
  ocaml_version = getVersion ocaml;
in

stdenv.mkDerivation {


  name = "ocaml-lwt-${version}";

  src = fetchzip {
    url = "https://github.com/ocsigen/lwt/archive/${version}.tar.gz";
    sha256 = "0gmhm282r8yi0gwcv0g2s7qchkfjmhqbqf4j9frlyv665ink9kxl";
  };

  buildInputs = [ ocaml_oasis pkgconfig which cryptopp ocaml findlib glib ncurses camlp4 ppx_tools ];

  propagatedBuildInputs = [ ocaml_react ocaml_ssl ocaml_text libev ];

  configureFlags = [ "--enable-glib" "--enable-ssl" "--enable-react" "--enable-camlp4"]
  ++ [ (if versionAtLeast ocaml_version "4.02" then "--enable-ppx" else "--disable-ppx") ];

  createFindlibDestdir = true;

  meta = with stdenv.lib; {
    homepage = http://ocsigen.org/lwt;
    description = "Lightweight thread library for Objective Caml";
    license = licenses.lgpl21;
    platforms = ocaml.meta.platforms or [];
    maintainers = with maintainers; [
      z77z vbgl gal_bolle
    ];
  };
}
