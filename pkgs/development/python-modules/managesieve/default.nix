{ lib
, buildPythonPackage
, fetchPypi
, pytestrunner
, pytest
}:

buildPythonPackage rec {
  pname = "managesieve";
  version = "0.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ee70e298e9b68eb81f93d52a1320a034fdc182f3927fdd551836fc93b0ed2c5f";
  };

  checkInputs = [ pytestrunner pytest ];

  meta = with lib; {
    description = "ManageSieve client library for remotely managing Sieve scripts";
    homepage    = "https://managesieve.readthedocs.io/";
    # PSFL for the python module, GPLv3 for sieveshell
    license     = with licenses; [ gpl3 psfl ];
    maintainers = with maintainers; [ dadada ];
  };
}
