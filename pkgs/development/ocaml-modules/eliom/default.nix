{ stdenv, fetchurl, which, ocsigen_server, ocsigen_deriving, ocaml,
  js_of_ocaml, ocaml_react, ocaml_lwt, calendar, cryptokit, tyxml,
  ipaddr, ocamlnet, ocaml_ssl, ocaml_pcre, ocaml_optcomp,
  reactivedata, opam, ppx_tools, ppx_deriving, findlib
, ocamlbuild
}:

assert stdenv.lib.versionAtLeast ocaml.version "4.02";

stdenv.mkDerivation rec
{
  pname = "eliom";
  version = "6.0.0";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "https://github.com/ocsigen/eliom/archive/${version}.tar.gz";
    sha256 = "1yaqi5fdzvi2ga412chw5rk3533a3xamwfmias1crk793d43cmpc";
  };

  patches = [ ./camlp4.patch ];

  buildInputs = [ ocaml which findlib ocamlbuild ocaml_optcomp opam ppx_tools ];

  propagatedBuildInputs = [ ocaml_lwt reactivedata tyxml ipaddr ocsigen_server ppx_deriving
                            ocsigen_deriving js_of_ocaml
                            calendar cryptokit ocamlnet ocaml_react ocaml_ssl ocaml_pcre ];

  installPhase = "opam-installer -i --prefix=$out --libdir=$OCAMLFIND_DESTDIR";

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

    maintainers = [ stdenv.lib.maintainers.gal_bolle ];
  };
}
