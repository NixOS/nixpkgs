{
  lib,
  buildDunePackage,
  fetchurl,
  xmlm,
  eio,
  logs,
  fmt,
  cstruct,
  cmdliner,
  alcotest,
  eio_main,
}:

buildDunePackage rec {
  pname = "wayland";
  version = "2.1";

  minimalOCamlVersion = "5.0";

  src = fetchurl {
    url = "https://github.com/talex5/ocaml-wayland/releases/download/v${version}/wayland-${version}.tbz";
    hash = "sha256-D/tTlYlU8e1O+HShIsBxqc8953rjQblj63tRPYAo88E=";
  };

  propagatedBuildInputs = [
    eio
    logs
    fmt
    cstruct
  ];

  buildInputs = [
    cmdliner
    xmlm
  ];

  checkInputs = [
    alcotest
    eio_main
  ];
  doCheck = true;

  meta = {
    description = "Pure OCaml Wayland protocol library";
    homepage = "https://github.com/talex5/ocaml-wayland";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.sternenseemann ];
    mainProgram = "wayland-scanner-ocaml";
  };
}
