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
  version = "2.9.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-2+D+747BpGXfGRu6JXYUl2LRWoyZhcn+qTq2Jdh1w2I=";
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
