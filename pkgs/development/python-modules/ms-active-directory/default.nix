{ lib
, buildPythonPackage
, dnspython
, fetchFromGitHub
, ldap3
, pyasn1
, pycryptodome
, pythonOlder
, pytz
, six
}:

buildPythonPackage rec {
  pname = "ms-active-directory";
  version = "1.12.1";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "zorn96";
    repo = "ms_active_directory";
    rev = "v${version}";
    hash = "sha256-mErQib8xTgo29iPAtiLnhxLXyFboAzyEW9A/QMseM6k=";
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

  pythonImportsCheck = [
    "ms_active_directory"
  ];

  meta = with lib; {
    description = "Python module for integrating with Microsoft Active Directory domains";
    homepage = "https://github.com/zorn96/ms_active_directory/";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
