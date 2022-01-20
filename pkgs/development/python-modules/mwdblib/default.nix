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
, requests
}:

buildPythonPackage rec {
  pname = "mwdblib";
  version = "4.0.0";

  src = fetchFromGitHub {
    owner = "CERT-Polska";
    repo = pname;
    rev = "v${version}";
    sha256 = "10in50a3nvwmvsnynjydj7jpkjik4qkv56kxql4v36hnqrfln0hz";
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

  pythonImportsCheck = [ "mwdblib" ];

  meta = with lib; {
    description = "Python client library for the mwdb service";
    homepage = "https://github.com/CERT-Polska/mwdblib";
    license = with licenses; [ bsd3 ];
    maintainers = with maintainers; [ fab ];
  };
}
