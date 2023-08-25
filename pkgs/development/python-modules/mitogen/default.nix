{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
}:

buildPythonPackage rec {
  pname = "mitogen";
  version = "0.3.4";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "mitogen-hq";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-tMpjmSqZffFGbo06W/FAut584F8eOPrcLKjj2bnB+Zo=";
  };

  # Tests require network access and Docker support
  doCheck = false;

  pythonImportsCheck = [
    "mitogen"
  ];

  meta = with lib; {
    description = "Python Library for writing distributed self-replicating programs";
    homepage = "https://github.com/mitogen-hq/mitogen";
    license = licenses.bsd3;
    maintainers = with maintainers; [ fab ];
  };
}
