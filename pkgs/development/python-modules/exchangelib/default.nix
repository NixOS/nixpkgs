{
  lib,
  buildPythonPackage,
  cached-property,
  defusedxml,
  dnspython,
  fetchFromGitHub,
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
  requests-mock,
  setuptools,
  tzdata,
  tzlocal,
}:

buildPythonPackage rec {
  pname = "exchangelib";
  version = "5.5.1";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "ecederstrand";
    repo = "exchangelib";
    tag = "v${version}";
    hash = "sha256-HO88wM0yzETWS0eBnLABCjYHGE5wFpcjQgC8wsSumWA=";
  };

  pythonRelaxDeps = [ "defusedxml" ];

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
    tzdata
    tzlocal
  ];

  optional-dependencies = {
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
    changelog = "https://github.com/ecederstrand/exchangelib/blob/${src.tag}/CHANGELOG.md";
    license = licenses.bsd2;
  };
}
