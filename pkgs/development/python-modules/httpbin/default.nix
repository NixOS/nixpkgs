{ lib
, brotlipy
, buildPythonPackage
, decorator
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
