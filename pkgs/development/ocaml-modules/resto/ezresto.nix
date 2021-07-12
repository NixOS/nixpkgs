{ lib, buildDunePackage, resto, resto-json, uri }:

buildDunePackage {
  pname = "ezresto";
  inherit (resto) src version meta useDune2 doCheck;

  propagatedBuildInputs = [
    uri
    resto
    resto-json
  ];
}
