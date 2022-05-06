{ lib
, buildPythonPackage
, fetchPypi
, findutils
, pytestCheckHook
, pythonOlder
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "extension-helpers";
  version = "1.0.0";
  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ca1bfac67c79cf4a7a0c09286ce2a24eec31bf17715818d0726318dd0e5050e6";
  };

  nativeBuildInputs = [
    setuptools-scm
  ];

  patches = [ ./permissions.patch ];

  checkInputs = [
    findutils
    pytestCheckHook
  ];

  # avoid import mismatch errors, as conftest.py is copied to build dir
  pytestFlagsArray = [
    "extension_helpers"
  ];

  disabledTests = [
    # https://github.com/astropy/extension-helpers/issues/43
    "test_write_if_different"
  ];

  pythonImportsCheck = [
    "extension_helpers"
  ];

  meta = with lib; {
    description = "Utilities for building and installing packages in the Astropy ecosystem";
    homepage = "https://github.com/astropy/extension-helpers";
    license = licenses.bsd3;
    maintainers = with maintainers; [ rmcgibbo ];
  };
}
