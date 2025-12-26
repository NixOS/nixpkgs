{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  setuptools-scm,
  packaging,
  requests,
}:

buildPythonPackage rec {
  pname = "rocketchat-api";
  version = "1.37.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jadolg";
    repo = "rocketchat_API";
    tag = version;
    hash = "sha256-N0IEPYN3H/KYZuTQZFTGZaDFZseGG1M6Kn5WX29afB8=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    packaging
    requests
  ];

  pythonImportsCheck = [
    "rocketchat_API"
    "rocketchat_API.APIExceptions"
    "rocketchat_API.APISections"
  ];

  # requires running a Rocket.Chat server
  doCheck = false;

  meta = {
    changelog = "https://github.com/jadolg/rocketchat_API/releases/tag/${src.tag}";
    description = "Python API wrapper for Rocket.Chat";
    homepage = "https://github.com/jadolg/rocketchat_API";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
