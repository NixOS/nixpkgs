{ lib, buildDunePackage, base64, benchmark, csv, cmdliner, wodan, afl-persistent
, mirage-block-ramdisk, mirage-block-unix }:

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
    /* io-page-unix */
    mirage-block-ramdisk
    mirage-block-unix
    wodan
  ];

  postInstall = ''
    moveToOutput bin "''${!outputBin}"
  '';

  meta = wodan.meta // {
    broken = true; # io-page-unix is no longer available
    description = "Wodan clients with Unix integration";
    mainProgram = "wodanc";
  };

}
