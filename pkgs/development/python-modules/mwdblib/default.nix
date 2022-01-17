{ lib
, beautifultable
, buildPythonPackage
, click
, click-default-group
, fetchFromGitHub
, humanize
, keyring
, python
, python-dateutil
, pythonOlder
, requests
}:

buildPythonPackage rec {
  pname = "mwdblib";
  version = "4.0.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "CERT-Polska";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-HwJLXcYWmrEJxX2asicmM8p55ZHNS+ut3pVvOxQoNoI=";
  };

  propagatedBuildInputs = [
    beautifultable
    click
    click-default-group
    humanize
    keyring
    python-dateutil
    requests
  ];

  checkPhase = ''
    runHook preCheck
    ${python.interpreter} -m unittest discover
    runHook postCheck
  '';

  pythonImportsCheck = [
    "mwdblib"
  ];

  meta = with lib; {
    description = "Python client library for the mwdb service";
    homepage = "https://github.com/CERT-Polska/mwdblib";
    license = with licenses; [ bsd3 ];
    maintainers = with maintainers; [ fab ];
  };
}
