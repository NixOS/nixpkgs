{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pyitachip2ir";
  version = "0.0.7";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-T/Q3tZTTwqlaHDR2l2nRLISC4LLrOPZZv14sRxYyqDQ=";
  };

  build-system = [ setuptools ];

  # Package has no tests
  doCheck = false;

  pythonImportsCheck = [ "pyitachip2ir" ];

  meta = {
    description = "Library for sending IR commands to an ITach IP2IR gateway";
    homepage = "https://github.com/alanfischer/itachip2ir";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
}
