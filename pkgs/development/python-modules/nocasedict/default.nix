{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
, six
}:

buildPythonPackage rec {
  pname = "nocasedict";
  version = "2.0.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-lgy2mfEgnagKw546tQqnNC/oyp9wYGwjRHpRBVBDXlA=";
  };

  propagatedBuildInputs = [
    six
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pytestFlagsArray = [
    "-W" "ignore::pytest.PytestRemovedIn8Warning"
  ];

  pythonImportsCheck = [
    "nocasedict"
  ];

  meta = with lib; {
    description = "A case-insensitive ordered dictionary for Python";
    homepage = "https://github.com/pywbem/nocasedict";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ freezeboy ];
  };
}
