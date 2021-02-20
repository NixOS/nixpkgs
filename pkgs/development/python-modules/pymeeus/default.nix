{ lib, buildPythonPackage, fetchPypi, pytest }:

buildPythonPackage rec {
  pname = "PyMeeus";
  version = "0.3.13";

  src = fetchPypi {
    inherit pname version;
    sha256 = "43b800a2571f3237e558d8d305e97f6ac4027977666e22af98448e0f1f86af86";
  };

  checkInputs = [ pytest ];

  checkPhase = ''
    pytest .
  '';

  meta = with lib; {
    homepage = "https://github.com/architest/pymeeus";
    description = "Library of astronomical algorithms";
    license = licenses.lgpl3;
    maintainers = with maintainers; [ jluttine ];
  };
}
