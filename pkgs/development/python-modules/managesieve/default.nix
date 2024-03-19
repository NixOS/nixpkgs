{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "managesieve";
  version = "0.8";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-2CCb6h69H58YT1byj/fkrfzGsMUbr0GHpJLcMpsSE/M=";
  };

  nativeCheckInputs = [ pytestCheckHook ];

  meta = with lib; {
    description = "ManageSieve client library for remotely managing Sieve scripts";
    mainProgram = "sieveshell";
    homepage = "https://managesieve.readthedocs.io/";
    # PSFL for the python module, GPLv3 only for sieveshell
    license = with licenses; [ gpl3Only psfl ];
    maintainers = with maintainers; [ dadada ];
  };
}
