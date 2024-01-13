{ lib, fetchFromGitHub, buildDunePackage, angstrom, lwt }:

buildDunePackage rec {
  pname = "angstrom-lwt-unix";

  inherit (angstrom) version src;

  propagatedBuildInputs = [ angstrom lwt ];

  doCheck = true;

  meta = {
    inherit (angstrom.meta) homepage license;
    description = "Lwt_unix support for Angstrom";
    maintainers = with lib.maintainers; [ romildo ];
  };
}
