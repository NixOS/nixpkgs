{ stdenv, fetchurl, ocaml, findlib, which, ocsigen_server, ocsigen_deriving,
  js_of_ocaml, ocaml_react, ocaml_lwt, calendar, cryptokit, tyxml,
  ocaml_ipaddr, ocamlnet, ocaml_ssl, ocaml_pcre, ocaml_optcomp}:

stdenv.mkDerivation
{
  name = "eliom-4.0.0";

  src = fetchurl {
    url = https://github.com/ocsigen/eliom/archive/4.0.0.tar.gz;
    sha256 = "1xf2l6lvngxzwaw6lvr6sgi48rz0wxg65q9lz4jzqjarkp0sx206";
  };

  buildInputs = [ocaml which ocsigen_server findlib ocsigen_deriving
                 js_of_ocaml ocaml_react ocaml_lwt calendar
                 cryptokit tyxml ocaml_ipaddr ocamlnet ocaml_ssl
                 ocaml_pcre ocaml_optcomp];

  preConfigure =
  ''chmod a+x configure
    sed s/deriving-ocsigen/deriving/g -i configure
  '';

  configureFlags = "--root $(out) --prefix /";

  dontAddPrefix = true;  

  createFindlibDestdir = true;
}
