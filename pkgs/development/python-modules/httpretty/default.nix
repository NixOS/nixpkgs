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
, rednose
, nose-randomly
, six
, mock
, eventlet
, pytest
, freezegun
}:

buildPythonPackage rec {
  pname = "httpretty";
  version = "1.0.2";

  # drop this for version > 0.9.7
  # Flaky tests: https://github.com/gabrielfalcao/HTTPretty/pull/394
  doCheck = stdenv.lib.versionAtLeast version "0.9.8";

  src = fetchPypi {
    inherit pname version;
    sha256 = "24a6fd2fe1c76e94801b74db8f52c0fb42718dc4a199a861b305b1a492b9d868";
  };

  propagatedBuildInputs = [ six ];

  checkInputs = [ nose sure coverage mock rednose pytest
    # Following not declared in setup.py
    nose-randomly requests tornado httplib2 nose-exclude freezegun
  ];

  checkPhase = ''
    nosetests tests/unit # functional tests cause trouble requiring /etc/protocol
  '';

  __darwinAllowLocalNetworking = true;

  # Those flaky tests are failing intermittently on all platforms
  NOSE_EXCLUDE = stdenv.lib.concatStringsSep "," [
    "tests.functional.test_httplib2.test_callback_response"
    "tests.functional.test_requests.test_streaming_responses"
    "tests.functional.test_httplib2.test_callback_response"
    "tests.functional.test_requests.test_httpretty_should_allow_adding_and_overwritting_by_kwargs_u2"
  ];

  meta = with stdenv.lib; {
    homepage = "https://httpretty.readthedocs.org/";
    description = "HTTP client request mocking tool";
    license = licenses.mit;
  };
}
