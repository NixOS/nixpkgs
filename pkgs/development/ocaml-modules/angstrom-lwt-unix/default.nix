{ lib, fetchFromGitHub, buildDunePackage, angstrom, ocaml_lwt }:

buildDunePackage rec {
  pname = "angstrom-lwt-unix";

  inherit (angstrom) version useDune2 src;

  minimumOCamlVersion = "4.03";

  propagatedBuildInputs = [ angstrom ocaml_lwt ];

  doCheck = true;

  meta = {
    inherit (angstrom.meta) homepage license;
    description = "Lwt_unix support for Angstrom";
    maintainers = with lib.maintainers; [ romildo ];
  };
}
