{ lib
, buildPythonPackage
, fetchFromGitHub
, requests
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pynetgear";
  version = "0.9.4";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "MatMaul";
    repo = pname;
    rev = "refs/tags/${version}";
    sha256 = "sha256-/oxwUukYq/a0WeO/XhkMW3Jj7I1icZZUDwh1mdbGi08=";
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
