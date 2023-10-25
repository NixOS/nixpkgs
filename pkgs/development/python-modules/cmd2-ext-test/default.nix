{ lib
, buildPythonPackage
, cmd2
, fetchPypi
, pytestCheckHook
, pythonOlder
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "cmd2-ext-test";
  version = "2.0.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-uTc+onurLilwQe0trESR3JGa5WFT1fCt3rRA7rhRpaY=";
  };

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    cmd2
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "cmd2_ext_test"
  ];

  meta = with lib; {
    description = "Plugin supports testing of a cmd2 application";
    homepage = "https://github.com/python-cmd2/cmd2/tree/master/plugins/ext_test";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
