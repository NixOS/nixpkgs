{ stdenv, lib, fetchzip, which, ocsigen_server, ocaml,
  lwt_react,
  opaline, ppx_deriving, findlib
, js_of_ocaml-ocamlbuild, js_of_ocaml-ppx, js_of_ocaml-ppx_deriving_json
, js_of_ocaml-lwt
, js_of_ocaml-tyxml
, lwt_ppx
, ocamlnet
}:

stdenv.mkDerivation rec
{
  pname = "eliom";
  version = "8.9.0";

  src = fetchzip {
    url = "https://github.com/ocsigen/eliom/archive/${version}.tar.gz";
    sha256 = "sha256:1b1vb3ilb54ffzb98mqa6zggqchsnjspbni8qxi6j42pbajp7p2l";
  };

  buildInputs = [ ocaml which findlib js_of_ocaml-ocamlbuild
    js_of_ocaml-ppx_deriving_json opaline
    ocamlnet
  ];

  propagatedBuildInputs = [
    js_of_ocaml-lwt
    js_of_ocaml-ppx
    js_of_ocaml-tyxml
    lwt_ppx
    lwt_react
    ocsigen_server
    ppx_deriving
  ];

  installPhase = "opaline -prefix $out -libdir $OCAMLFIND_DESTDIR";

  setupHook = [ ./setup-hook.sh ];

  meta = {
    homepage = "http://ocsigen.org/eliom/";
    description = "OCaml Framework for programming Web sites and client/server Web applications";

    longDescription =''Eliom is a framework for programming Web sites
    and client/server Web applications. It introduces new concepts to
    simplify programming common behaviours and uses advanced static
    typing features of OCaml to check many properties of the Web site
    at compile time. If you want to write a Web application, Eliom
    makes possible to write the whole application as a single program
    (client and server parts). A syntax extension is used to
    distinguish both parts and the client side is compiled to JS using
    Ocsigen Js_of_ocaml.'';

    license = lib.licenses.lgpl21;

    maintainers = [ lib.maintainers.gal_bolle ];
  };
}
