{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "littleutils";
  version = "0.2.4";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-x4NbAQIM7ULikRGLfXj7FrwtmhtPP0LzyzeHu02lPRk=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "littleutils" ];

  meta = {
    description = "Small collection of Python utility functions";
    homepage = "https://github.com/alexmojaki/littleutils";
    changelog = "https://github.com/alexmojaki/littleutils/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jluttine ];
  };
}
