{ lib
, buildPythonPackage
, fetchPypi
, flake8
, pycodestyle
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "flake8-debugger";
  version = "4.1.2";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-UrACVglB422b+Ab8olI9x/uFYKKV1fGm4VrC3tenOEA=";
  };

  propagatedBuildInputs = [
    flake8
    pycodestyle
  ];

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "flake8_debugger"
  ];

  meta = with lib; {
    description = "ipdb/pdb statement checker plugin for flake8";
    homepage = "https://github.com/jbkahn/flake8-debugger";
    license = licenses.mit;
    maintainers = with maintainers; [ johbo ];
  };
}
