{ stdenv, fetchFromGitHub, buildDunePackage, angstrom, ocaml_lwt }:

buildDunePackage rec {
  pname = "angstrom-lwt-unix";

  inherit (angstrom) version src;

  minimumOCamlVersion = "4.03";

  propagatedBuildInputs = [ angstrom ocaml_lwt ];

  doCheck = true;

  meta = {
    inherit (angstrom.meta) homepage license;
    description = "Lwt_unix support for Angstrom";
    maintainers = with stdenv.lib.maintainers; [ romildo ];
  };
}
