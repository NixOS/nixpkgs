{ lib, ocaml, fetchFromGitHub, buildDunePackage, base64, bos, core, lwt_react
, ocamlgraph, ppx_sexp_conv, rresult, sexplib, tyxml }:

buildDunePackage rec {
  pname = "bistro";
  version = "unstable-2021-11-13";

  useDune2 = true;

  src = fetchFromGitHub {
    owner = "pveber";
    repo = pname;
    rev = "fb285b2c6d8adccda3c71e2293bceb01febd6624";
    sha256 = "sha256-JChDU1WH8W9Czkppx9SHiVIu9/7QFWJy2A89oksp0Ek=";
  };

  propagatedBuildInputs = [
    base64
    bos
    core
    lwt_react
    ocamlgraph
    ppx_sexp_conv
    rresult
    sexplib
    tyxml
  ];

  minimalOCamlVersion = "4.12";

  meta = {
    inherit (src.meta) homepage;
    description = "Build and execute typed scientific workflows";
    maintainers = [ lib.maintainers.vbgl ];
    license = lib.licenses.gpl2;
  };
}
