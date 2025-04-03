{
  stdenv,
  lib,
  fetchFromGitHub,
  ocaml,
  findlib,
  opaline,
  calendar,
  eliom,
  js_of_ocaml-ppx_deriving_json,
}:

stdenv.mkDerivation rec {
  pname = "ocsigen-toolkit";
  name = "ocaml${ocaml.version}-${pname}-${version}";
  version = "3.3.4";

  propagatedBuildInputs = [
    calendar
    js_of_ocaml-ppx_deriving_json
    eliom
  ];
  nativeBuildInputs = [
    ocaml
    findlib
    opaline
    eliom
  ];

  strictDeps = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $OCAMLFIND_DESTDIR
    export OCAMLPATH=$out/lib/ocaml/${ocaml.version}/site-lib/:$OCAMLPATH
    make install
    opaline -prefix $out
    runHook postInstall
  '';

  src = fetchFromGitHub {
    owner = "ocsigen";
    repo = pname;
    rev = version;
    hash = "sha256-6ccu8WJxUwpR5YyB4j1jQPWba8GhQDxuw+IDHswQpSA=";
  };

  meta = {
    homepage = "http://ocsigen.org/ocsigen-toolkit/";
    description = " User interface widgets for Ocsigen applications";
    license = lib.licenses.lgpl21;
    maintainers = [ lib.maintainers.gal_bolle ];
    inherit (ocaml.meta) platforms;
  };

}
