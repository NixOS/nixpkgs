{ lib
, buildPythonPackage
, isPy27
, fetchPypi
, mock
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "cssutils";
  version = "2.0.0";

  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "984b5dbe3a2a0483d7cb131609a17f4cbaa34dda306c419924858a88588fed7c";
  };

  checkInputs = [
    mock
    pytestCheckHook
  ];

  disabledTests = [
    "test_parseUrl" # accesses network
  ];

  pythonImportsCheck = [ "cssutils" ];

  meta = with lib; {
    description = "A CSS Cascading Style Sheets library for Python";
    homepage = "https://github.com/jaraco/cssutils";
    changelog = "https://github.com/jaraco/cssutils/blob/v${version}/CHANGES.rst";
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ dotlambda ];
  };
}
