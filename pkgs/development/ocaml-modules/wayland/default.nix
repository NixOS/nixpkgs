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
  version = "0.2";

  minimumOCamlVersion = "4.08";

  useDune2 = true;

  src = fetchurl {
    url = "https://github.com/talex5/ocaml-wayland/releases/download/v${version}/wayland-v${version}.tbz";
    sha256 = "4eb323e42a8c64e9e49b15a588342bfcc1e99640305cb261d128c75612d9458c";
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
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.sternenseemann ];
    homepage = "https://github.com/talex5/ocaml-wayland";
  };
}
