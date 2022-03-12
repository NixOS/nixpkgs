{ lib
, async-timeout
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, xmltodict
}:

buildPythonPackage rec {
  pname = "pymediaroom";
  version = "0.6.5";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "dgomes";
    repo = pname;
    rev = version;
    sha256 = "sha256-iRxPCunbgU4kbTLBKNFS6IlTP/6jGoQfWx0TDqTXymE=";
  };

  propagatedBuildInputs = [
    async-timeout
    xmltodict
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [
    "pymediaroom"
  ];

  meta = with lib; {
    description = "Python Remote Control for Mediaroom STB";
    homepage = "https://github.com/dgomes/pymediaroom";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
