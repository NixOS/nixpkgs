{
  lib,
  buildPythonPackage,
  dnspython,
  fetchFromGitHub,
  ldap3,
  pyasn1,
  pycryptodome,
  pythonOlder,
  pytz,
  setuptools,
  six,
}:

buildPythonPackage rec {
  pname = "ms-active-directory";
  version = "1.14.1";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "zorn96";
    repo = "ms_active_directory";
    rev = "refs/tags/v${version}";
    hash = "sha256-ZFIeG95+G9ofk54bYZpqu8uVfzjqsOrwWlIZvQgIWRI=";
  };

  build-system = [ setuptools ];

  dependencies = [
    dnspython
    ldap3
    pyasn1
    pycryptodome
    pytz
    six
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "ms_active_directory" ];

  meta = with lib; {
    description = "Python module for integrating with Microsoft Active Directory domains";
    homepage = "https://github.com/zorn96/ms_active_directory/";
    changelog = "https://github.com/zorn96/ms_active_directory/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
