{ lib
, buildPythonPackage
, fetchFromGitHub
, httpx
, pyjwt
, pythonOlder
, yarl
}:

buildPythonPackage rec {
  pname = "elmax-api";
  version = "0.0.3";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "albertogeniola";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-ZqPDnIiFzxS6nU19bfEgnqEsuz7oI+Z4ac6br6Gr4Vk=";
  };

  propagatedBuildInputs = [
    httpx
    pyjwt
    yarl
  ];

  # Test require network access
  doCheck = false;

  pythonImportsCheck = [
    "elmax_api"
  ];

  meta = with lib; {
    description = "Python library for interacting with the Elmax cloud";
    homepage = "https://github.com/albertogeniola/elmax-api";
    changelog = "https://github.com/albertogeniola/elmax-api/releases/tag/v${version}";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
