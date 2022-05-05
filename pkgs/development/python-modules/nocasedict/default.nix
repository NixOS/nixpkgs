{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
, six
}:

buildPythonPackage rec {
  pname = "nocasedict";
  version = "1.0.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-giC5e6BrCOst7e13TEBsd+DKDVNSrnEkn2+dHyoXvXs=";
  };

  propagatedBuildInputs = [
    six
  ];

  checkInputs = [
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
