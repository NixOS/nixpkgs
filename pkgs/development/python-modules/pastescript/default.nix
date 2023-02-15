{ lib
, buildPythonPackage
, fetchPypi
, nose
, python
, pytestCheckHook
, six
, paste
, pastedeploy
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pastescript";
  version = "3.3.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "PasteScript";
    inherit version;
    hash = "sha256-3eyAGhOsZn4JTt3ij5AhLN6nvcmhjUNxsI9abvfS66I=";
  };

  propagatedBuildInputs = [
    paste
    pastedeploy
    six
  ];

  # test suite seems to unset PYTHONPATH
  doCheck = false;

  nativeCheckInputs = [
    nose
    pytestCheckHook
  ];

  pythonNamespaces = [
    "paste"
  ];

  disabledTestPaths = [
    "appsetup/testfiles"
  ];

  pythonImportsCheck = [
    "paste.script"
    "paste.deploy"
    "paste.util"
  ];

  meta = with lib; {
    description = "A pluggable command-line frontend, including commands to setup package file layouts";
    homepage = "https://github.com/cdent/pastescript/";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
