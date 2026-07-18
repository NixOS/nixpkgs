{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  httpx,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pyprusalink";
  version = "3.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "home-assistant-libs";
    repo = "pyprusalink";
    tag = version;
    hash = "sha256-qgcwbpQxjaoG/XDRv0kjryT0MqswYb7s6lhWKGHQB/4=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [ httpx ];

  # Module doesn't have tests
  doCheck = false;

  pythonImportsCheck = [ "pyprusalink" ];

  meta = {
    description = "Library to communicate with PrusaLink";
    homepage = "https://github.com/home-assistant-libs/pyprusalink";
    changelog = "https://github.com/home-assistant-libs/pyprusalink/releases/tag/${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
}
