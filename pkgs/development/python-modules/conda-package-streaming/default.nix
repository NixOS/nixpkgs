{ lib
, stdenv
, buildPythonPackage
, fetchFromGitHub
, boto3
, bottle
, requests
, zstandard
}:

buildPythonPackage rec {

  pname = "conda-package-streaming";
  version = "0.9.0";

  format = "flit";

  src = fetchFromGitHub {
    owner = "conda";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-UTql2M+9eFDuHOwLYYKJ751wEcOfLJYzfU6+WF8Je2g=";
  };

  propagatedBuildInputs = [
    boto3
    bottle
    requests
    zstandard
  ];

  pythonImportsCheck = [ "conda_package_streaming" ];

  meta = with lib; {
    description = "A library to read new and old format .conda and .tar.bz2 conda packages";
    homepage = "https://github.com/conda/conda-package-streaming";
    # lazy_wheel.py inherits MIT from pip, all else is BSD3
    license = with licenses; [ bsd3 mit ];
    maintainers = with maintainers; [ r-burns ];
  };
}
