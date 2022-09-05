{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "fqdn";
  version = "1.5.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "ypcrts";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-T0CdWWr8p3JVhp3nol5hyxsrD3951JE2EDpFt+m+3bE=";
  };

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "fqdn"
  ];

  meta = with lib; {
    description = "RFC-compliant FQDN validation and manipulation";
    homepage = "https://github.com/ypcrts/fqdn";
    license = licenses.mpl20;
    maintainers = with maintainers; [ fab ];
  };
}
