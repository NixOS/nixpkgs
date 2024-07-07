{ lib, ocamlPackages }:

let inherit (ocamlPackages) buildDunePackage csv uutf; in

buildDunePackage {
  pname = "csvtool";
  inherit (csv) src version;

  duneVersion = "3";

  buildInputs = [ csv uutf ];

  doCheck = true;

  meta = csv.meta // {
    description = "Command line tool for handling CSV files";
    mainProgram = "csvtool";
  };
}
