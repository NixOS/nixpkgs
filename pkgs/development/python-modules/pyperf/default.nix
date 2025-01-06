{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  psutil,
  unittestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pyperf";
  version = "2.8.1";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-7xA+IaTQSZkxUAMCai1lnEinz85eFEDwPW5yWRQAcTo=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [ psutil ];

  nativeCheckInputs = [ unittestCheckHook ];

  unittestFlagsArray = [
    "-s"
    "pyperf/tests/"
    "-v"
  ];

  pythonImportsCheck = [ "pyperf" ];

  meta = with lib; {
    description = "Python module to generate and modify perf";
    mainProgram = "pyperf";
    homepage = "https://pyperf.readthedocs.io/";
    changelog = "https://github.com/psf/pyperf/releases/tag/${version}";
    license = licenses.mit;
    maintainers = [ ];
  };
}
