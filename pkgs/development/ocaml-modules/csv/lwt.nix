{ lib, buildDunePackage, csv, lwt }:

buildDunePackage {
  pname = "csv-lwt";
  inherit (csv) src version meta;

  preConfigure = ''
    substituteInPlace lwt/dune --replace '(libraries   bytes' '(libraries '
  '';


  propagatedBuildInputs = [ csv lwt ];

  doCheck = true;
}
