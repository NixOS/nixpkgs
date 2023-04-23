{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "managesieve";
  version = "0.7.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "44930a3b48332d23b35a5305ae7ba47904d4485ed1b7a22208b7d5ad9d60427a";
  };

  nativeCheckInputs = [ pytestCheckHook ];

  meta = with lib; {
    description = "ManageSieve client library for remotely managing Sieve scripts";
    homepage = "https://managesieve.readthedocs.io/";
    # PSFL for the python module, GPLv3 only for sieveshell
    license = with licenses; [ gpl3Only psfl ];
    maintainers = with maintainers; [ dadada ];
  };
}
