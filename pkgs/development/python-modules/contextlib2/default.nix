{
  lib,
  buildPythonPackage,
  fetchPypi,
  python,
  pythonAtLeast,
  pythonOlder,
  unittestCheckHook,
}:

buildPythonPackage rec {
  pname = "contextlib2";
  version = "21.6.0";
  format = "setuptools";

  # Python 3.11 not currently supported
  # https://github.com/jazzband/contextlib2/issues/43
  disabled = pythonOlder "3.6" || pythonAtLeast "3.11";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-qx4r/h0B2Wjht+jZAjvFHvNQm7ohe7cwzuOCfh7oKGk=";
  };

  nativeCheckInputs = [ unittestCheckHook ];

  pythonImportsCheck = [ "contextlib2" ];

  meta = with lib; {
    description = "Backports and enhancements for the contextlib module";
    homepage = "https://contextlib2.readthedocs.org/";
    license = licenses.psfl;
    maintainers = with maintainers; [ ];
  };
}
