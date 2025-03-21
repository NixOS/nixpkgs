{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  httpx,
  pyjwt,
  pythonOlder,
  websockets,
  yarl,
}:

buildPythonPackage rec {
  pname = "elmax-api";
  version = "0.0.6.1";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "albertogeniola";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-KMszoyeAIUyHCAuSUuCgbMos7SrQXncz38WqyPblJuE=";
  };

  build-system = [ setuptools ];

  dependencies = [
    httpx
    pyjwt
    websockets
    yarl
  ];

  # Test require network access
  doCheck = false;

  pythonImportsCheck = [ "elmax_api" ];

  meta = with lib; {
    description = "Python library for interacting with the Elmax cloud";
    homepage = "https://github.com/albertogeniola/elmax-api";
    changelog = "https://github.com/albertogeniola/elmax-api/releases/tag/v${version}";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
