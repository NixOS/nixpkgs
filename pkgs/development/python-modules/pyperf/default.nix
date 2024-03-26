{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, psutil
, unittestCheckHook
, setuptools
}:

buildPythonPackage rec {
  pname = "pyperf";
  version = "2.6.3";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-l1L+dJwh5GClZLs/Uvwxm4ksYu5hxROLSpu/lK0nVeY=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    psutil
  ];

  nativeCheckInputs = [
    unittestCheckHook
  ];

  unittestFlagsArray = [
    "-s"
    "pyperf/tests/"
    "-v"
  ];

  pythonImportsCheck = [
    "pyperf"
  ];

  meta = with lib; {
    description = "Python module to generate and modify perf";
    mainProgram = "pyperf";
    homepage = "https://pyperf.readthedocs.io/";
    changelog = "https://github.com/psf/pyperf/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
