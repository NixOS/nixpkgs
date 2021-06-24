{ lib
, buildPythonPackage
, fetchFromGitHub
, isPy3k
, requests
, requests_oauthlib
, isodate
, certifi
, enum34
, typing
, aiohttp
, aiodns
, pytest
, httpretty
, mock
, futures
, trio
}:

buildPythonPackage rec {
  version = "0.6.21";
  pname = "msrest";

  # no tests in PyPI tarball
  # see https://github.com/Azure/msrest-for-python/pull/152
  src = fetchFromGitHub {
    owner = "Azure";
    repo = "msrest-for-python";
    rev = "v${version}";
    sha256 = "sha256-IlBwlVQ/v+vJmCWNbFZKGL6a9K09z4AYrPm3kwaA/nI=";
  };

  propagatedBuildInputs = [
    requests requests_oauthlib isodate certifi
  ] ++ lib.optionals (!isPy3k) [ enum34 typing ]
    ++ lib.optionals isPy3k [ aiohttp aiodns ];

  checkInputs = [ pytest httpretty ]
    ++ lib.optionals (!isPy3k) [ mock futures ]
    ++ lib.optional isPy3k trio;

  # Deselected tests require network access
  checkPhase = ''
    pytest tests/ -k "not test_conf_async_trio_requests"
  '';

  meta = with lib; {
    description = "The runtime library 'msrest' for AutoRest generated Python clients.";
    homepage = "https://github.com/Azure/msrest-for-python";
    license = licenses.mit;
    maintainers = with maintainers; [ bendlas jonringer maxwilson ];
  };
}
