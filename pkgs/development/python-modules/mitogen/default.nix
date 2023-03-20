{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
}:

buildPythonPackage rec {
  pname = "mitogen";
  version = "0.3.3";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "mitogen-hq";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-cx0q2Y9A6UzpdD1kuGBtXIs9oBGFpkIyvPfN2hj+A1g=";
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
