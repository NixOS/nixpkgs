{ lib
, backports-zoneinfo
, buildPythonPackage
, cached-property
, defusedxml
, dnspython
, fetchFromGitHub
, fetchpatch
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

  patches = [
    (fetchpatch {
      name = "tests-timezones.patch";
      url = "https://github.com/ecederstrand/exchangelib/commit/d5d386f54adec8ab02f871332b89e1176c214ba2.diff";
      hash = "sha256-E3Ys6IDJ/yMsvi+1GKbwckkhbNrc9JLM/+GrPtUz+mY=";
    })
    (fetchpatch {
      name = "tests-timezones-2.patch";
      url = "https://github.com/ecederstrand/exchangelib/commit/419eafcd9261bfd0617823ee437204d5556a8271.diff";
      excludes = [ "tests/test_ewsdatetime.py" ];
      hash = "sha256-dSp6NkNT5dHOg8XgDi8sR3t3hq46sNtPjUXva2YfFSU=";
    })
  ];

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

  nativeCheckInputs = [
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
