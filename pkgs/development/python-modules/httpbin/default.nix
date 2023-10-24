{ lib
, brotlicffi
, buildPythonPackage
, decorator
, fetchPypi
, flask
, flask-limiter
, flasgger
, itsdangerous
, markupsafe
, raven
, six
, pytestCheckHook
, setuptools
, werkzeug
}:

buildPythonPackage rec {
  pname = "httpbin";
  version = "0.10.1";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-e4WWvrDnWntlPDnR888mPW1cR20p4d9ve7K3C/nwaj0=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    brotlicffi
    decorator
    flask
    flask-limiter
    flasgger
    itsdangerous
    markupsafe
    raven
    six
    werkzeug
  ] ++ raven.optional-dependencies.flask;

  nativeCheckInputs = [
    pytestCheckHook
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
    homepage = "https://github.com/psf/httpbin";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
