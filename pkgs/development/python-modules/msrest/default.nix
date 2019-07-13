{ lib
, buildPythonPackage
, fetchPypi
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
  version = "0.6.8";
  pname = "msrest";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0yd43fnmfxkvk3idkyn67ziwjgkwkn261kicr3szjibpqjqcpsf9";
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
    homepage = "https://azure.microsoft.com/en-us/develop/python/";
    license = licenses.mit;
    maintainers = with maintainers; [ bendlas jonringer ];
  };
}
