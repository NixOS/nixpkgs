{ stdenv, fetchzip, which, ocsigen_server, ocaml,
  lwt_react,
  opaline, ppx_deriving, findlib
, js_of_ocaml-ocamlbuild, js_of_ocaml-ppx, js_of_ocaml-ppx_deriving_json
, js_of_ocaml-lwt
, js_of_ocaml-tyxml
, lwt_ppx
}:

if !stdenv.lib.versionAtLeast ocaml.version "4.07"
then throw "eliom is not available for OCaml ${ocaml.version}"
else

stdenv.mkDerivation rec
{
  pname = "eliom";
  version = "6.10.1";

  src = fetchzip {
    url = "https://github.com/ocsigen/eliom/archive/${version}.tar.gz";
    sha256 = "006722wcmhsfhyzv3qbgrrn53fbv9v4i31z52a0pznb6cll45nkm";
  };

  buildInputs = [ ocaml which findlib js_of_ocaml-ocamlbuild js_of_ocaml-ppx_deriving_json opaline
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
    homepage = http://ocsigen.org/eliom/;
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

    license = stdenv.lib.licenses.lgpl21;

    maintainers = [ stdenv.lib.maintainers.gal_bolle ];
  };
}
