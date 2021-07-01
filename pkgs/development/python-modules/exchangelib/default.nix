{ lib, fetchFromGitHub, buildPythonPackage,
  pythonOlder,
  lxml, tzlocal, python-dateutil, pygments, requests-kerberos,
  defusedxml, cached-property, isodate, requests_ntlm, dnspython,
  psutil, requests-mock, pyyaml,
  oauthlib, requests_oauthlib, tzdata,
  flake8, backports-zoneinfo
}:

buildPythonPackage rec {
  pname = "exchangelib";
  version = "4.4.0";
  disabled = pythonOlder "3.5";

  # tests are not present in the PyPI version
  src = fetchFromGitHub {
    owner = "ecederstrand";
    repo = pname;
    rev = "v${version}";
    sha256 = "0d6hfbawp68x18ryxamkamf8kgc55xbrll89g3swrqnm2rrhzrqf";
  };

  checkInputs = [ psutil requests-mock pyyaml
    flake8
  ];
  propagatedBuildInputs = [
    lxml tzlocal tzdata python-dateutil pygments requests-kerberos
    defusedxml cached-property isodate requests_ntlm dnspython
    oauthlib requests_oauthlib
  ] ++ lib.optionals (pythonOlder "3.9") [
    backports-zoneinfo
  ];

  meta = with lib; {
    description = "Client for Microsoft Exchange Web Services (EWS)";
    homepage    = "https://github.com/ecederstrand/exchangelib";
    license     = licenses.bsd2;
    maintainers = with maintainers; [ catern ];
  };
}
