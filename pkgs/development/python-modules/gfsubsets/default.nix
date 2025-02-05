{
  lib,
  buildPythonPackage,
  fetchPypi,
  fonttools,
  importlib-resources,
  setuptools,
  setuptools-scm,
  youseedee,
}:

buildPythonPackage rec {
  pname = "gfsubsets";
  version = "2024.9.25";
  gitTag = "v2024.02.05";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-jEuIBNQ89Le3Rbk0W4PLl9LE7rP0IcE6RAzyfhZb7lY=";
  };

  pyproject = true;

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    fonttools
    importlib-resources
    youseedee
  ];

  # Package has no unit tests.
  doCheck = false;
  pythonImportsCheck = [ "gfsubsets" ];

  meta = with lib; {
    description = "Codepoint definitions for the Google Fonts subsetter";
    homepage = "https://github.com/googlefonts/nam-files";
    changelog = "https://github.com/googlefonts/nam-files/releases/tag/${gitTag}";
    license = licenses.asl20;
    maintainers = with maintainers; [ danc86 ];
  };
}
