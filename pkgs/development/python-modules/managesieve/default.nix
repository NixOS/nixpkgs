{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "managesieve";
  version = "0.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1dx0j8hhjwip1ackaj2m4hqrrx2iiv846ic4wa6ymrawwb8iq8m6";
  };

  checkInputs = [ pytestCheckHook ];

  meta = with lib; {
    description = "ManageSieve client library for remotely managing Sieve scripts";
    homepage = "https://managesieve.readthedocs.io/";
    # PSFL for the python module, GPLv3 only for sieveshell
    license = with licenses; [ gpl3Only psfl ];
    maintainers = with maintainers; [ dadada ];
  };
}
