{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytest,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "ansicolors";
  version = "1.1.8";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    extension = "zip";
    hash = "sha256-mflPXjNIoLzUPILl/EQUATzMGdcL2TmtceATPOnDcuA=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytest ];

  checkPhase = ''
    py.test
  '';

  pythonImportsCheck = [ "colors" ];

  meta = {
    homepage = "https://github.com/verigak/colors/";
    changelog = "https://pypi.org/project/ansicolors/${finalAttrs.version}/";
    description = "ANSI colors for Python";
    license = lib.licenses.isc;
    maintainers = [ ];
    hasNoMaintainersButDependents = true;
  };
})
