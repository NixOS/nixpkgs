{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fonttools,
  importlib-resources,
  setuptools,
  setuptools-scm,
  youseedee,
}:

buildPythonPackage rec {
  pname = "gfsubsets";
  version = "2025.11.04";

  src = fetchFromGitHub {
    owner = "googlefonts";
    repo = "nam-files";
    tag = "v${version}";
    hash = "sha256-mMsmccIuilKeOUjt68etYefibuorjlW32gLcLgV8jxo=";
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
    changelog = "https://github.com/googlefonts/nam-files/releases/tag/${src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ danc86 ];
  };
}
