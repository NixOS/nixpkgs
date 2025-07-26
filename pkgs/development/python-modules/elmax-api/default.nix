{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  httpx,
  pyjwt,
  websockets,
  yarl,
}:

buildPythonPackage rec {
  pname = "elmax-api";
  version = "0.0.6.4rc0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "albertogeniola";
    repo = "elmax-api";
    tag = "v${version}";
    hash = "sha256-BYVfP8B+p4J4gW+64xh9bT9sDcu/lk0R+MvLsYLwRfQ=";
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
