{ lib
, buildPythonPackage
, fetchPypi
, numpy
, pytestCheckHook
, pythonOlder
, setuptools
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "quantities";
  version = "0.15.0";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-nqMeKg11F88k1UaxQUbe+SkmOZk6YWzKYbh173lrSys=";
  };

  nativeBuildInputs = [
    setuptools
    setuptools-scm
  ];

  propagatedBuildInputs = [
    numpy
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  disabledTests = [
    # test fails with numpy 1.24
    "test_mul"
  ];

  pythonImportsCheck = [
    "quantities"
  ];

  meta = with lib; {
    description = "Quantities is designed to handle arithmetic and conversions of physical quantities";
    homepage = "https://python-quantities.readthedocs.io/";
    changelog = "https://github.com/python-quantities/python-quantities/blob/v${version}/CHANGES.txt";
    license = licenses.bsd2;
    maintainers = with maintainers; [ ];
  };
}
