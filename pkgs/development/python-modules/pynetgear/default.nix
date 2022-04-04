{ lib
, buildPythonPackage
, fetchFromGitHub
, requests
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pynetgear";
  version = "0.9.3";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "MatMaul";
    repo = pname;
    rev = version;
    sha256 = "sha256-zydSx2OZowf+1KZ5ZJ/1FDVqDZQZ4U0+q62eB1+s+WY=";
  };

  propagatedBuildInputs = [
    requests
  ];

  pythonImportsCheck = [
    "pynetgear"
  ];

  # Tests don't pass
  # https://github.com/MatMaul/pynetgear/issues/109
  doCheck = false;

  meta = with lib; {
    description = "Module for interacting with Netgear wireless routers";
    homepage = "https://github.com/MatMaul/pynetgear";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
