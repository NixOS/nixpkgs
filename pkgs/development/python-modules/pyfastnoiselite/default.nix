{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  numpy,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "pyfastnoiselite";
  version = "0.0.7";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "tizilogic";
    repo = "PyFastNoiseLite";
    tag = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-Dyi7FeNnlX3EA8qSylapvZJ4/02ayQC5EBtRY6KBJRA=";
  };

  build-system = [ setuptools ];

  dependencies = [ numpy ];

  # has no tests
  doCheck = false;

  pythonImportsCheck = [ "pyfastnoiselite" ];

  meta = {
    description = "Wrapper for Auburns' FastNoise Lite noise generation library";
    homepage = "https://github.com/tizilogic/PyFastNoiseLite";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ SuperSandro2000 ];
  };
})
