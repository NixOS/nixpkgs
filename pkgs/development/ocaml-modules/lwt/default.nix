{ stdenv, fetchzip, which, cryptopp, ocaml, findlib, ocamlbuild, camlp4
, ocaml_react, ocaml_ssl, libev, pkgconfig, ncurses, ocaml_oasis, glib
, ppx_tools, result
, ppxSupport ? stdenv.lib.versionAtLeast ocaml.version "4.02"
}:

stdenv.mkDerivation rec {
  name = "ocaml-lwt-${version}";
  version = "2.6.0";

  src = fetchzip {
    url = "https://github.com/ocsigen/lwt/archive/${version}.tar.gz";
    sha256 = "0f1h83zh60rspm4fxd96z9h5bkhq1n1q968hgq92sq4a6bfi1c2w";
  };

  buildInputs = [ ocaml_oasis pkgconfig which cryptopp ocaml findlib ocamlbuild glib ncurses camlp4 ]
  ++ stdenv.lib.optional ppxSupport ppx_tools;

  propagatedBuildInputs = [ result ocaml_react ocaml_ssl libev ];

  configureScript = "ocaml setup.ml -configure";
  prefixKey = "--prefix ";
  configureFlags = [ "--enable-glib" "--enable-ssl" "--enable-react" "--enable-camlp4" ]
  ++ [ (if ppxSupport then "--enable-ppx" else "--disable-ppx") ];

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
