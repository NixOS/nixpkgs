{ lib
, beautifulsoup4
, buildPythonPackage
, fetchFromGitHub
, gssapi
, impacket
, ldap3
, lxml
, pyasn1
, pycryptodome
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pywerview";
  version = "0.5.2";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "the-useless-one";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-BWH9zYrlbzQC0/cc5k5BlXWyh38gI+hwwTCWhe1xgog=";
  };

  propagatedBuildInputs = [
    beautifulsoup4
    gssapi
    impacket
    ldap3
    lxml
    pycryptodome
    pyasn1
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [
    "pywerview"
  ];

  meta = with lib; {
    description = "Module for PowerSploit's PowerView support";
    homepage = "https://github.com/the-useless-one/pywerview";
    changelog = "https://github.com/the-useless-one/pywerview/releases/tag/v${version}";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ fab ];
  };
}
