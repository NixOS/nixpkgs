{ lib
, buildPythonPackage
, fetchPypi
, fetchpatch
, pythonRelaxDepsHook

# build-system
, setuptools

# dependencies
, brotlicffi
, decorator
, flasgger
, flask
, greenlet
, six
, werkzeug

# optional-dependencies
, gunicorn
, gevent

# tests
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "httpbin";
  version = "0.10.1";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-e4WWvrDnWntlPDnR888mPW1cR20p4d9ve7K3C/nwaj0=";
  };

  patches = [
    (fetchpatch {
      # backport flask 3.0 support; drop after 0.10.1
      url = "https://github.com/psf/httpbin/commit/c1d9e33049263fed3cb27806a97f094acc350905.patch";
      hash = "sha256-SYJgQN3ERDgLIaBc4eqDfey+EX4z6CSxLoAA7j+16xI=";
    })
  ];

  nativeBuildInputs = [
    setuptools
    pythonRelaxDepsHook
  ];

  pythonRelaxDeps = [
    "greenlet"
  ];

  propagatedBuildInputs = [
    brotlicffi
    decorator
    flask
    flasgger
    greenlet
    six
    werkzeug
  ];

  passthru.optional-dependencies = {
    mainapp = [
      gunicorn
      gevent
    ];
  };

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
