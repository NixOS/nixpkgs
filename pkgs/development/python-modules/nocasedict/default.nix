{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
, six
}:

buildPythonPackage rec {
  pname = "nocasedict";
  version = "1.0.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-fBEdpM79JEQzy2M3ev8IGkD4S92unm83bGfwhsD4Bto=";
  };

  propagatedBuildInputs = [
    six
  ];

  nativeCheckInputs = [
    pytestCheckHook
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
