{ lib
, buildPythonPackage
, pythonOlder
, fetchPypi
, ptpython
, ipython
, setuptools
, setuptools-scm
, setuptools-generate
}:

let
  pname = "repl-python-wakatime";
  version = "0.0.6";
in

buildPythonPackage {
  inherit pname version;
  format = "pyproject";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-s2UelniMn4+wWILbVIIKidRCFaOvo/nNNofA7yf2+9c=";
  };

  nativeBuildInputs = [
    setuptools
    setuptools-scm
    setuptools-generate
  ];

  propagatedBuildInputs = [
    ptpython
    ipython
  ];

  pythonImportsCheck = [
    "repl_python_wakatime"
  ];

  meta = with lib; {
    description = "Python REPL plugin for automatic time tracking and metrics generated from your programming activity";
    homepage = "https://github.com/wakatime/repl-python-wakatime";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ jfvillablanca ];
  };
}
