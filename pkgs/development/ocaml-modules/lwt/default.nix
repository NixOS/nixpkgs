{stdenv, fetchzip, which, cryptopp, ocaml, findlib, ocaml_react, ocaml_ssl, libev, pkgconfig, ncurses, ocaml_oasis, ocaml_text, glib, camlp4}:

let
  version = "2.4.6";
  inherit (stdenv.lib) optional getVersion versionAtLeast;
  ocaml_version = getVersion ocaml;
in

stdenv.mkDerivation {


  name = "ocaml-lwt-${version}";

  src = fetchzip {
    url = "https://github.com/ocsigen/lwt/archive/${version}.tar.gz";
    sha256 = "0idci0zadpb8hmblszsrvg6yf36w5a9y6rsdwjc3jww71dgrw5d9";
  };

  buildInputs = [ocaml_oasis pkgconfig which cryptopp ocaml findlib glib libev ncurses camlp4];

  propagatedBuildInputs = [ ocaml_react ocaml_ssl ocaml_text ];

  configureFlags = [ "--enable-react" "--enable-glib" "--enable-ssl" "--enable-text" "--disable-ppx" ]
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
