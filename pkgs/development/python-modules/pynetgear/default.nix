{ lib
, buildPythonPackage
, fetchFromGitHub
, requests
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pynetgear";
  version = "0.10.2";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "MatMaul";
    repo = pname;
    rev = "refs/tags/${version}";
    sha256 = "sha256-/JynomaMARuE3svTdnnczHmP839S0EXLbE7xG9dYEv0=";
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
