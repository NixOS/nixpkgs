{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  packaging,
  requests,
}:

buildPythonPackage rec {
  pname = "rocketchat-api";
  version = "1.33.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jadolg";
    repo = "rocketchat_API";
    rev = "refs/tags/${version}";
    hash = "sha256-t1t0uksmdPTrksDF0K3/f3KxAv0fX2W8wDIIcWAPEVs=";
  };

  build-system = [ setuptools ];

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
    description = "Python API wrapper for Rocket.Chat";
    homepage = "https://github.com/jadolg/rocketchat_API";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
