{ lib
, backports-zoneinfo
, buildPythonPackage
, cached-property
, defusedxml
, dnspython
, fetchFromGitHub
, flake8
, isodate
, lxml
, oauthlib
, psutil
, pygments
, python-dateutil
, pythonOlder
, pytz
, pyyaml
, requests
, requests_ntlm
, requests-oauthlib
, requests-kerberos
, requests-mock
, tzdata
, tzlocal
}:

buildPythonPackage rec {
  pname = "exchangelib";
  version = "4.7.6";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "ecederstrand";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-Oarmdc2PuE4kQ/qUqQhuzdTpIrrMFCK72CrVmoSH1DI=";
  };

  propagatedBuildInputs = [
    cached-property
    defusedxml
    dnspython
    isodate
    lxml
    oauthlib
    pygments
    requests
    requests_ntlm
    requests-oauthlib
    requests-kerberos
    tzdata
    tzlocal
  ] ++ lib.optionals (pythonOlder "3.9") [
    backports-zoneinfo
  ];

  checkInputs = [
    flake8
    psutil
    python-dateutil
    pytz
    pyyaml
    requests-mock
  ];

  pythonImportsCheck = [
    "exchangelib"
  ];

  meta = with lib; {
    description = "Client for Microsoft Exchange Web Services (EWS)";
    homepage = "https://github.com/ecederstrand/exchangelib";
    license = licenses.bsd2;
    maintainers = with maintainers; [ catern ];
  };
}
