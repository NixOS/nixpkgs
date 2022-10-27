{ lib
, buildDunePackage
, fetchurl
, xmlm
, lwt
, logs
, fmt
, cstruct
, cmdliner
, alcotest-lwt
}:

buildDunePackage rec {
  pname = "wayland";
  version = "1.1";

  minimalOCamlVersion = "4.08";

  src = fetchurl {
    url = "https://github.com/talex5/ocaml-wayland/releases/download/v${version}/wayland-${version}.tbz";
    sha256 = "0b7czgh08i6xcx3fsz6vd19sfyngwi0i27jdzg8cnjgrgwnagv6d";
  };

  propagatedBuildInputs = [
    lwt
    logs
    fmt
    cstruct
  ];

  buildInputs = [
    cmdliner
    xmlm
  ];

  checkInputs = [
    alcotest-lwt
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
