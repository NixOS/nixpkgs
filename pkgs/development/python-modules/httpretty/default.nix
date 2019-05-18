{ stdenv
, buildPythonPackage
, fetchPypi
, tornado
, requests
, httplib2
, sure
, nose
, nose-exclude
, coverage
, certifi
, urllib3
, rednose
, nose-randomly
, six
, mock
}:

buildPythonPackage rec {
  pname = "httpretty";
  version = "0.9.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "01b52d45077e702eda491f4fe75328d3468fd886aed5dcc530003e7b2b5939dc";
  };

  propagatedBuildInputs = [ six ];

  checkInputs = [ nose sure coverage mock rednose
    # Following not declared in setup.py
    nose-randomly requests tornado httplib2 nose-exclude
  ];

  __darwinAllowLocalNetworking = true;

  # Those flaky tests are failing intermittently on all platforms
  NOSE_EXCLUDE = stdenv.lib.concatStringsSep "," [
    "tests.functional.test_httplib2.test_callback_response"
    "tests.functional.test_requests.test_streaming_responses"
  ];

  meta = with stdenv.lib; {
    homepage = "https://httpretty.readthedocs.org/";
    description = "HTTP client request mocking tool";
    license = licenses.mit;
  };
}
