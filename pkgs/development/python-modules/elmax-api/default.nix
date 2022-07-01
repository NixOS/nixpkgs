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
  version = "0.0.2";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "albertogeniola";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-YUnLi8+ibUgWoMFMgZPSPbpr286bnWBefxjOV7JfCuY=";
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
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
