{
  lib,
  backports-zoneinfo,
  buildPythonPackage,
  cached-property,
  defusedxml,
  dnspython,
  fetchFromGitHub,
  flake8,
  isodate,
  lxml,
  oauthlib,
  psutil,
  pygments,
  python-dateutil,
  pythonOlder,
  pytz,
  pyyaml,
  requests,
  requests-ntlm,
  requests-gssapi,
  requests-oauthlib,
  requests-kerberos,
  requests-mock,
  setuptools,
  tzdata,
  tzlocal,
}:

buildPythonPackage rec {
  pname = "exchangelib";
  version = "5.2.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "ecederstrand";
    repo = "exchangelib";
    rev = "refs/tags/v${version}";
    hash = "sha256-4XcJNbnBCaSrGwfgDAlo4wCOjlwq2rLjSxRXniuzdzk=";
  };

  build-system = [ setuptools ];

  dependencies = [
    cached-property
    defusedxml
    dnspython
    isodate
    lxml
    oauthlib
    pygments
    requests
    requests-ntlm
    requests-oauthlib
    requests-kerberos
    tzdata
    tzlocal
  ] ++ lib.optionals (pythonOlder "3.9") [ backports-zoneinfo ];

  passthru.optional-dependencies = {
    complete = [
      requests-gssapi
      # requests-negotiate-sspi
    ];
    kerberos = [ requests-gssapi ];
    # sspi = [
    #   requests-negotiate-sspi
    # ];
  };

  nativeCheckInputs = [
    flake8
    psutil
    python-dateutil
    pytz
    pyyaml
    requests-mock
  ];

  pythonImportsCheck = [ "exchangelib" ];

  meta = with lib; {
    description = "Client for Microsoft Exchange Web Services (EWS)";
    homepage = "https://github.com/ecederstrand/exchangelib";
    changelog = "https://github.com/ecederstrand/exchangelib/blob/v${version}/CHANGELOG.md";
    license = licenses.bsd2;
    maintainers = with maintainers; [ catern ];
  };
}
