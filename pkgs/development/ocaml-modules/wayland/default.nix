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
  version = "1.0";

  minimumOCamlVersion = "4.08";

  useDune2 = true;

  src = fetchurl {
    url = "https://github.com/talex5/ocaml-wayland/releases/download/v${version}/wayland-${version}.tbz";
    sha256 = "bf8fd0057242d11f1c265c11cfa5de3c517ec0ad5994eae45e1efe3aac034510";
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
