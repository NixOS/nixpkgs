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
  six,
}:

buildPythonPackage rec {
  pname = "ms-active-directory";
  version = "1.13.0";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "zorn96";
    repo = "ms_active_directory";
    rev = "refs/tags/v${version}";
    hash = "sha256-+wfhtEGuC1R5jbEnWm4mDHIR096KKEcG/K8SuItwjGk=";
  };

  propagatedBuildInputs = [
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
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
