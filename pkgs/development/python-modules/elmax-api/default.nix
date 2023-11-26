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
  version = "0.0.5";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "albertogeniola";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-57pmmH7f893H71CMhdnahvbN/5F2yfrVZ6MFpYQ4+mQ=";
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
