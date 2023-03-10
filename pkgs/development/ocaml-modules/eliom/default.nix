{ stdenv
, lib
, fetchFromGitHub
, which
, ocsigen_server
, ocaml
, lwt_react
, opaline
, ocamlbuild
, ppx_deriving
, findlib
, js_of_ocaml-ocamlbuild
, js_of_ocaml-ppx
, js_of_ocaml-ppx_deriving_json
, js_of_ocaml-lwt
, js_of_ocaml-tyxml
, lwt_ppx
, ocamlnet
, ocsipersist
}:

stdenv.mkDerivation rec {
  pname = "eliom";
  version = "9.4.0";

  src = fetchFromGitHub {
    owner = "ocsigen";
    repo = "eliom";
    rev = version;
    sha256 = "sha256:1yn8mqxv9yz51x81j8wv1jn7l7crm8azp1m2g4zn5nz2s4nmfv6q";
  };

  nativeBuildInputs = [
    ocaml
    which
    findlib
    opaline
    ocamlbuild
  ];
  buildInputs = [
    js_of_ocaml-ocamlbuild
    js_of_ocaml-ppx_deriving_json
    ocamlnet
  ];

  propagatedBuildInputs = [
    js_of_ocaml-lwt
    js_of_ocaml-ppx
    js_of_ocaml-tyxml
    lwt_ppx
    lwt_react
    ocsigen_server
    ocsipersist
    ppx_deriving
  ];

  strictDeps = true;

  installPhase = ''
    runHook preInstall
    opaline -prefix $out -libdir $OCAMLFIND_DESTDIR
    runHook postInstall
  '';

  setupHook = [ ./setup-hook.sh ];

  meta = {
    homepage = "http://ocsigen.org/eliom/";
    description = "OCaml Framework for programming Web sites and client/server Web applications";

    longDescription = ''Eliom is a framework for programming Web sites
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
