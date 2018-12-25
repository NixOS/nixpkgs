{ lib
, buildPythonPackage
, fetchPypi
, pytest
}:

buildPythonPackage rec {
  pname = "portalocker";
  version = "1.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1832pnpb2c5basg47ks7ipfvvwflcm7s4r8whkir607mwjn75fmm";
  };

  checkInputs = [ pytest ];
  checkPhase = ''
    # Based on https://github.com/WoLpH/portalocker/blob/master/pytest.ini
    py.test tests/*.py --doctest-modules
  '';

  meta = with lib; {
    description = "Easy API to file locking";
    homepage = https://github.com/WoLpH/portalocker;
    license = licenses.psfl;
    maintainers = with maintainers; [ ivan ];
  };
}
