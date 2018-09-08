{ lib
, buildPythonPackage
, fetchPypi
, pytest
}:

buildPythonPackage rec {
  pname = "jdcal";
  version = "1.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ea0a5067c5f0f50ad4c7bdc80abad3d976604f6fb026b0b3a17a9d84bb9046c9";
  };

  checkInputs = [ pytest ];

  checkPhase = ''
    py.test
  '';

  meta = {
    description = "A module containing functions for converting between Julian dates and calendar dates";
    homepage = https://github.com/phn/jdcal;
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ lihop ];
  };
}