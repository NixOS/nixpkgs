{ lib
, buildPythonPackage
, fetchPypi

# build-system
, setuptools

# dependencies
, ansible-core

# tests
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "ansible-vault-rw";
  version = "2.1.0";
  pyproject = true;

  src = fetchPypi {
    pname = "ansible-vault";
    inherit version;
    hash = "sha256-XOj9tUcPFEm3a/B64qvFZIDa1INWrkBchbaG77ZNvV4";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    ansible-core
  ];

  # Otherwise tests will fail to create directory
  # Permission denied: '/homeless-shelter'
  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  # no tests in sdist, no 2.1.0 tag on git
  doCheck = false;

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = with lib; {
    description = "This project aim to R/W an ansible-vault yaml file.";
    homepage = "https://github.com/tomoh1r/ansible-vault";
    changelog =
      "https://github.com/tomoh1r/ansible-vault/blob/master/CHANGES.txt";
    license = licenses.gpl3;
    maintainers = with maintainers; [ StillerHarpo ];
  };
}
