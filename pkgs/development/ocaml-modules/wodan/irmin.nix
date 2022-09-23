{ lib, buildDunePackage, irmin-chunk, irmin-git, irmin-unix
, mirage-block-ramdisk, mirage-block-unix, wodan }:

buildDunePackage rec {
  pname = "wodan-irmin";
  inherit (wodan) version src useDune2;

  propagatedBuildInputs = [
    /* io-page-unix */ # No longer available in nixpkgs
    irmin-chunk
    irmin-git
    irmin-unix
    mirage-block-ramdisk
    mirage-block-unix
    wodan
  ];

  meta = wodan.meta // {
    # wodan is currently incompatible with irmin 2.3.0.
    # additionally upgrading to current master (unclear
    # if the issue is fixed there) is not possible as it
    # depends on a custom fork of mirage-block
    broken = true;
    description = "Wodan as an Irmin store";
  };
}
