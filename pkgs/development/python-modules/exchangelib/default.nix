{ lib, fetchFromGitHub, buildPythonPackage,
  pythonOlder,
  lxml, tzlocal, python-dateutil, pygments, requests-kerberos,
  defusedxml, cached-property, isodate, requests_ntlm, dnspython,
  psutil, requests-mock, pyyaml,
  oauthlib, requests_oauthlib,
  flake8,
}:

buildPythonPackage rec {
  pname = "exchangelib";
  version = "4.1.0";
  disabled = pythonOlder "3.5";

  # tests are not present in the PyPI version
  src = fetchFromGitHub {
    owner = "ecederstrand";
    repo = pname;
    rev = "v${version}";
    sha256 = "0lkhjiz78x00d5gzn455660f31f8y4fcrqcn6rh0m41r1ar5im17";
  };

  checkInputs = [ psutil requests-mock pyyaml
    flake8
  ];
  propagatedBuildInputs = [
    lxml tzlocal python-dateutil pygments requests-kerberos
    defusedxml cached-property isodate requests_ntlm dnspython
    oauthlib requests_oauthlib
  ];

  meta = with lib; {
    description = "Client for Microsoft Exchange Web Services (EWS)";
    homepage    = "https://github.com/ecederstrand/exchangelib";
    license     = licenses.bsd2;
    maintainers = with maintainers; [ catern ];
  };
}
