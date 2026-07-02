{
  lib,
  buildPythonPackage,
  fetchPypi,
  psutil,
  unittestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pyperf";
  version = "2.10.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-3ZPM/aeSFHJSk+lfH6bgDLSmStzxMmA5SG1OH5HKqmI=";
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

  meta = {
    description = "Python module to generate and modify perf";
    mainProgram = "pyperf";
    homepage = "https://pyperf.readthedocs.io/";
    changelog = "https://github.com/psf/pyperf/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
