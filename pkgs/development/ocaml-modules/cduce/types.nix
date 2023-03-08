{ lib, buildDunePackage, num }:

let
  common = import ./common.nix {
    inherit lib;
  };
in
buildDunePackage rec {
  pname = "cduce-types";

  minimalOCamlVersion = "4.04.2";

  inherit (common) src version;

  propagatedBuildInputs = [
    num
  ];

  meta = with lib; common.meta // {
    description = ''
      This library implements set-theoretic types with
       semantic subtyping. It is at the heart of the CDuce compiler, but
       can also be reused as a stand-alone library to experiment with
       semantic subtyping.
    '';
  };
}
