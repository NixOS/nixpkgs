{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  httpx,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pyprusalink";
  version = "2.1.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "home-assistant-libs";
    repo = "pyprusalink";
    tag = version;
    hash = "sha256-Opip696hXV1gqFC1cWfrSCkrsldl7M7XZAqUaVkDy7M=";
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
    license = with lib.licenses; [ asl20 ];
    maintainers = with lib.maintainers; [ fab ];
  };
}
