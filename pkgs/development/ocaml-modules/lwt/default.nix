{ stdenv, buildOcaml, fetchzip, which, cryptopp, ocaml, findlib, ocamlbuild, camlp4
, ocaml_react, ocaml_ssl, libev, pkgconfig, ncurses, ocaml_oasis, glib
, ppx_tools, result, cppo
, ppxSupport ? stdenv.lib.versionAtLeast ocaml.version "4.02"
}:

let param =
  if stdenv.lib.versionAtLeast ocaml.version "4.02"
  then {
    version = "2.7.1";
    sha256 = "0w7f59havrl2fsnvs84lm7wlqpsrldg80gy5afpnpr21zkw22g8w";
  } else {
    version = "2.6.0";
    sha256 = "0f1h83zh60rspm4fxd96z9h5bkhq1n1q968hgq92sq4a6bfi1c2w";
  };
in

buildOcaml rec {
  name = "lwt";
  inherit (param) version;

  src = fetchzip {
    url = "https://github.com/ocsigen/lwt/archive/${version}.tar.gz";
    inherit (param) sha256;
  };

  buildInputs = [ ocaml_oasis pkgconfig which cryptopp ocaml findlib ocamlbuild glib ncurses camlp4 cppo ]
  ++ stdenv.lib.optional ppxSupport ppx_tools;

  propagatedBuildInputs = [ result ocaml_react ocaml_ssl libev ];

  configureScript = "ocaml setup.ml -configure";
  prefixKey = "--prefix ";
  configureFlags = [ "--enable-glib" "--enable-ssl" "--enable-react" "--enable-camlp4" ]
  ++ [ (if ppxSupport then "--enable-ppx" else "--disable-ppx") ];

  createFindlibDestdir = true;

  hasSharedObjects = true;

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
