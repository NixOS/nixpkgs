{ lib, buildPythonPackage, fetchPypi, ansible-core, ... }:

buildPythonPackage rec {
  pname = "ansible-vault-rw";
  version = "2.1.0";
  format = "setuptools";
  src = fetchPypi {
    pname = "ansible-vault";
    inherit version;
    sha256 = "sha256-XOj9tUcPFEm3a/B64qvFZIDa1INWrkBchbaG77ZNvV4";
  };
  propagatedBuildInputs = [ ansible-core ];

  # Otherwise tests will fail to create directory
  # Permission denied: '/homeless-shelter'
  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  meta = with lib; {
    description = "This project aim to R/W an ansible-vault yaml file.";
    homepage = "https://github.com/tomoh1r/ansible-vault";
    changelog =
      "https://github.com/tomoh1r/ansible-vault/blob/master/CHANGES.txt";
    license = licenses.gpl3;
    maintainers = with maintainers; [ StillerHarpo ];
  };
}
