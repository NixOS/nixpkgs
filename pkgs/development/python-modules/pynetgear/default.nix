{ lib
, buildPythonPackage
, fetchFromGitHub
, requests
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pynetgear";
  version = "0.10.6";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "MatMaul";
    repo = pname;
    rev = "refs/tags/${version}";
    sha256 = "sha256-lpCBwz7B6QHLmFQwOz+QA3oJ2GOrE1Y/qjWE328vD2A=";
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
