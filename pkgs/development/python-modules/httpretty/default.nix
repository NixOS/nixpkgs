{ lib, stdenv
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
  version = "1.0.3";

  # drop this for version > 0.9.7
  # Flaky tests: https://github.com/gabrielfalcao/HTTPretty/pull/394
  doCheck = stdenv.lib.versionAtLeast version "0.9.8";

  src = fetchPypi {
    inherit pname version;
    sha256 = "9335cbd8f38745e0e2dc4755d8932a77d378d93e15804969504b1e6b568d613c";
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

  meta = with lib; {
    homepage = "https://httpretty.readthedocs.org/";
    description = "HTTP client request mocking tool";
    license = licenses.mit;
  };
}
