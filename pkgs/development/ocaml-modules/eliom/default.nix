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

  meta = {
    homepage = http://ocsigen.org/eliom/;
    description = "Ocaml Framework for programming Web sites and client/server Web applications";

    longDescription =''Eliom is a framework for programming Web sites
    and client/server Web applications. It introduces new concepts to
    simplify programming common behaviours and uses advanced static
    typing features of OCaml to check many properties of the Web site
    at compile time. If you want to write a Web application, Eliom
    makes possible to write the whole application as a single program
    (client and server parts). A syntax extension is used to
    distinguish both parts and the client side is compiled to JS using
    Ocsigen Js_of_ocaml.'';

    license = stdenv.lib.licenses.lgpl21;

    platforms = ocaml.meta.platforms;

    maintainers = [ stdenv.lib.maintainers.gal_bolle ];
  };
}
