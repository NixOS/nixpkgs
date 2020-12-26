{ lib, buildDunePackage, io-page-unix, irmin-chunk, irmin-git, irmin-unix
, mirage-block-ramdisk, mirage-block-unix, wodan }:

buildDunePackage rec {
  pname = "wodan-irmin";
  inherit (wodan) version src useDune2;

  propagatedBuildInputs = [
    io-page-unix
    irmin-chunk
    irmin-git
    irmin-unix
    mirage-block-ramdisk
    mirage-block-unix
    wodan
  ];

  meta = wodan.meta // { description = "Wodan as an Irmin store"; };

}
