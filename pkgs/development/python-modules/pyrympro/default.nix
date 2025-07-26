{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pyrympro";
  version = "0.0.9";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "OnFreund";
    repo = "pyrympro";
    tag = "v${version}";
    hash = "sha256-+KgYdiVuX8Ycw0Odte/EXsoWiMaLmTU6zTeJCw9jwvs=";
  };

  build-system = [ setuptools ];

  dependencies = [ aiohttp ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "pyrympro" ];

  meta = with lib; {
    description = "Module to interact with Read Your Meter Pro";
    homepage = "https://github.com/OnFreund/pyrympro";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
