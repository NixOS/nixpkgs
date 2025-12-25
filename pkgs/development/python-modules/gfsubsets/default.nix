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
  version = "2025.11.4";
  gitTag = "v2024.02.05";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-k6Ula9qK/1Sy2ZhunqFcya/0hnDZEv4nptogefvtikk=";
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

  meta = {
    description = "Codepoint definitions for the Google Fonts subsetter";
    homepage = "https://github.com/googlefonts/nam-files";
    changelog = "https://github.com/googlefonts/nam-files/releases/tag/${gitTag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ danc86 ];
  };
}
