{ lib
, brotlipy
, buildPythonPackage
, decorator
, fetchpatch
, fetchPypi
, flask
, flask-limiter
, itsdangerous
, markupsafe
, raven
, six
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "httpbin";
  version = "0.7.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-y7N3kMkVdfTxV1f0KtQdn3KesifV7b6J5OwXVIbbjfo=";
  };

  patches = [
    (fetchpatch {
      # Replaces BaseResponse class with Response class for Werkezug 2.1.0 compatibility
      # https://github.com/postmanlabs/httpbin/pull/674
      url = "https://github.com/postmanlabs/httpbin/commit/5cc81ce87a3c447a127e4a1a707faf9f3b1c9b6b.patch";
      sha256 = "sha256-SbEWjiqayMFYrbgAPZtSsXqSyCDUz3z127XgcKOcrkE=";
    })
  ];

  propagatedBuildInputs = [
    brotlipy
    flask
    flask-limiter
    markupsafe
    decorator
    itsdangerous
    raven
    six
  ];

  checkInputs = [
    pytestCheckHook
  ];

  pytestFlagsArray = [
    "test_httpbin.py"
  ];

  disabledTests = [
    # Tests seems to be outdated
    "test_anything"
    "test_get"
    "test_redirect_n_equals_to_1"
    "test_redirect_n_higher_than_1"
    "test_redirect_to_post"
    "test_relative_redirect_n_equals_to_1"
    "test_relative_redirect_n_higher_than_1"
  ];

  pythonImportsCheck = [
    "httpbin"
  ];

  meta = with lib; {
    description = "HTTP Request and Response Service";
    homepage = "https://github.com/kennethreitz/httpbin";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
