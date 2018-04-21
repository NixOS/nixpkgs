{ lib
, buildPythonPackage
, fetchPypi
, pytest
}:

buildPythonPackage rec {
  pname = "jdcal";
  version = "1.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b760160f8dc8cc51d17875c6b663fafe64be699e10ce34b6a95184b5aa0fdc9e";
  };

  checkInputs = [ pytest ];

  checkPhase = ''
    py.test
  '';

  meta = {
    description = "A module containing functions for converting between Julian dates and calendar dates";
    homepage = "https://github.com/phn/jdcal";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ lihop ];
  };
}