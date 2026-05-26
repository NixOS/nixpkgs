{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  wheel,
}:

buildPythonPackage rec {
  pname = "pyyardian";
  version = "1.3.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "h3l1o5";
    repo = "pyyardian";
    tag = version;
    hash = "sha256-LOHE8vGrT25sgjhcNarMOi0hzpPpHjVIeVq7CezYicY=";
  };

  nativeBuildInputs = [
    setuptools
    wheel
  ];

  propagatedBuildInputs = [ aiohttp ];

  # Tests require network access
  doCheck = false;

  pythonImportsCheck = [ "pyyardian" ];

  meta = {
    description = "Module for interacting with the Yardian irrigation controller";
    homepage = "https://github.com/h3l1o5/pyyardian";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
