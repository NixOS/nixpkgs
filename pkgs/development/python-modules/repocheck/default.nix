{ lib
, buildPythonPackage
, fetchFromGitHub
}:

buildPythonPackage rec {
  pname = "repocheck";
  version = "2015-08-05";
  format = "setuptools";

  src = fetchFromGitHub {
    sha256 = "1jc4v5zy7z7xlfmbfzvyzkyz893f5x2k6kvb3ni3rn2df7jqhc81";
    rev = "ee48d0e88d3f5814d24a8d1f22d5d83732824688";
    repo = "repocheck";
    owner = "kynikos";
  };

  meta = with lib; {
    inherit (src.meta) homepage;
    description = "Check the status of code repositories under a root directory";
    license = licenses.gpl3Plus;
  };

}
