{ lib
, buildPythonPackage
, cffi
, fetchPypi
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "cmarkgfm";
  version = "0.8.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-/oWbDpjSIrS0WAIgB9qsJ1fpcPBnHUXlXQGTHBtLs8s=";
  };

  propagatedNativeBuildInputs = [
    cffi
  ];

  propagatedBuildInputs = [
    cffi
  ];

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "cmarkgfm"
  ];

  meta = with lib; {
    description = "Minimal bindings to GitHub's fork of cmark";
    homepage = "https://github.com/jonparrott/cmarkgfm";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
