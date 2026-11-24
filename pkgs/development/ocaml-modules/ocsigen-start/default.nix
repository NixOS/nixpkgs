{
  buildDunePackage,
  lib,
  fetchFromGitHub,
  ocsigen-toolkit,
  pgocaml_ppx,
  safepass,
  yojson,
  cohttp-lwt-unix,
  eliom,
  resource-pooling,
  ocsigen-ppx-rpc,
  ocsigen-dune-rules,
  js_of_ocaml-ppx_deriving_json,
}:

buildDunePackage {
  pname = "ocsigen-start";
  version = "8.0.0+git-2026-11-01";

  minimalOCamlVersion = "5.3";

  nativeBuildInputs = [
    eliom
    ocsigen-dune-rules
  ];
  buildInputs = [
    ocsigen-ppx-rpc
    js_of_ocaml-ppx_deriving_json
  ];
  propagatedBuildInputs = [
    pgocaml_ppx
    safepass
    ocsigen-toolkit
    yojson
    resource-pooling
    cohttp-lwt-unix
  ];

  src = fetchFromGitHub {
    owner = "ocsigen";
    repo = "ocsigen-start";
    rev = "6a01579e13a2fb0dc0f8feb063b8aaeff4009450";
    hash = "sha256-g1ruN8eNx1+PX0oA0uTB1wm5RMLsO8p4owJ2b9BJlDc=";
  };

  postInstall = ''
    ln -s $OCAMLFIND_DESTDIR/eliom/templates $dev/eliom-distillery-templates
  '';

  meta = {
    homepage = "http://ocsigen.org/ocsigen-start";
    description = "Eliom application skeleton";
    longDescription = ''
      An Eliom application skeleton, ready to use to build your own application with users, (pre)registration, notifications, etc.
    '';
    license = lib.licenses.lgpl21Only;
    maintainers = [ lib.maintainers.gal_bolle ];
  };

}
