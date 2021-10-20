{ lib, buildDunePackage, base64, benchmark, csv, cmdliner, wodan, afl-persistent
, io-page-unix, mirage-block-ramdisk, mirage-block-unix }:

buildDunePackage rec {
  outputs = [ "bin" "out" ];
  pname = "wodan-unix";
  inherit (wodan) version src useDune2;

  propagatedBuildInputs = [
    afl-persistent
    base64
    benchmark
    cmdliner
    csv
    io-page-unix
    mirage-block-ramdisk
    mirage-block-unix
    wodan
  ];

  postInstall = ''
    moveToOutput bin "''${!outputBin}"
  '';

  meta = wodan.meta // { description = "Wodan clients with Unix integration"; };

}
