{ lib, buildDunePackage, cstruct, async_unix }:

buildDunePackage rec {
  pname = "cstruct-async";
  inherit (cstruct) src version meta useDune2;

  propagatedBuildInputs = [
    async_unix
    cstruct
  ];
}
