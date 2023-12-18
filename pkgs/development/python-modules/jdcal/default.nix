{ lib
, buildPythonPackage
, fetchPypi
, pytest
}:

buildPythonPackage rec {
  pname = "jdcal";
  version = "1.4.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "472872e096eb8df219c23f2689fc336668bdb43d194094b5cc1707e1640acfc8";
  };

  nativeCheckInputs = [ pytest ];

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
