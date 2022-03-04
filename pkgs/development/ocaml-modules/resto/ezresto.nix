{ lib, buildDunePackage, resto, resto-json, uri }:

buildDunePackage {
  pname = "ezresto";
  inherit (resto) src version meta doCheck;

  propagatedBuildInputs = [
    uri
    resto
    resto-json
  ];
}
