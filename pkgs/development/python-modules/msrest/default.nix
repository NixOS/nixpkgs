{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonAtLeast
, requests
, requests_oauthlib
, isodate
, certifi
, aiohttp
, aiodns
, pytest
, httpretty
, trio
}:

buildPythonPackage rec {
  version = "0.6.4";
  pname = "msrest";

  # no tests in PyPI tarball
  # see https://github.com/Azure/msrest-for-python/pull/152
  src = fetchFromGitHub {
    owner = "Azure";
    repo = "msrest-for-python";
    rev = "v${version}";
    sha256 = "0ilrc06qq0dw4qqzq1dq2vs6nymc39h19w52dwcyawwfalalnjzi";
  };

  propagatedBuildInputs = [
    requests requests_oauthlib isodate certifi
    # optional
    aiohttp aiodns
  ];

  checkInputs = [ pytest httpretty ]
    ++ lib.optional (pythonAtLeast "3.5") trio;

  # Deselected tests require network access
  checkPhase = ''
    pytest tests/ -k "not test_conf_async_trio_requests"
  '';

  meta = with lib; {
    description = "The runtime library 'msrest' for AutoRest generated Python clients.";
    homepage = "https://azure.microsoft.com/en-us/develop/python/";
    license = licenses.mit;
    maintainers = with maintainers; [ bendlas ];
  };
}
