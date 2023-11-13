{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, psutil
, unittestCheckHook
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "pyperf";
  version = "2.6.2";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
     sha256 = "sha256-ZNj63OanT0ePKYMsHqoqBIVmVev/FyktUjf8gxfDo8U=";
  };

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    psutil
  ];

  nativeCheckInputs = [
    unittestCheckHook
  ];

  unittestFlagsArray = [ "-s" "pyperf/tests/" "-v" ];

  meta = with lib; {
    description = "Python module to generate and modify perf";
    homepage = "https://pyperf.readthedocs.io/";
    license = licenses.mit;
    maintainers = [ mikecm ];
  };
}