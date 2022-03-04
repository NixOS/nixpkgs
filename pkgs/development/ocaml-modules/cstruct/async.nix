{ lib, buildDunePackage, cstruct, async_unix }:

buildDunePackage rec {
  pname = "cstruct-async";
  inherit (cstruct) src version meta;

  propagatedBuildInputs = [
    async_unix
    cstruct
  ];
}
