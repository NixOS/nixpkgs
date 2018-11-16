{ stdenv, buildOcaml, fetchzip, which, cryptopp, ocaml, findlib, ocamlbuild, camlp4
, react, ssl, libev, pkgconfig, ncurses, glib
, ppx_tools, result, cppo
, ppxSupport ? stdenv.lib.versionAtLeast ocaml.version "4.02"
, version ? if stdenv.lib.versionAtLeast ocaml.version "4.02" then "2.7.1" else "2.6.0"
}:

if !stdenv.lib.versionAtLeast ocaml.version "4"
 || stdenv.lib.versionAtLeast ocaml.version "4.06"
then throw "lwt is not available for OCaml ${ocaml.version}"
else

let sha256 = {
  "3.0.0" = "0wwhnl9hppixcsdisinj1wmffx0nv6hkpm01z9qvkngkrazi3i88";
  "2.7.1" = "0w7f59havrl2fsnvs84lm7wlqpsrldg80gy5afpnpr21zkw22g8w";
  "2.6.0" = "0f1h83zh60rspm4fxd96z9h5bkhq1n1q968hgq92sq4a6bfi1c2w";
}."${version}"; in

let optionals = stdenv.lib.optionals (!stdenv.lib.versionAtLeast version "3"); in

buildOcaml rec {
  name = "lwt";
  inherit version;

  src = fetchzip {
    url = "https://github.com/ocsigen/lwt/archive/${version}.tar.gz";
    inherit sha256;
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ which cryptopp ocaml findlib ocamlbuild glib ncurses camlp4 cppo ]
  ++ stdenv.lib.optional ppxSupport ppx_tools;

  propagatedBuildInputs = [ result ]
  ++ optionals [ react ssl ]
  ++ [ libev ];

  configureScript = "ocaml setup.ml -configure";
  prefixKey = "--prefix ";
  configureFlags =
  optionals [ "--enable-glib" "--enable-ssl" "--enable-react" ]
  ++ [ "--enable-camlp4" ]
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
