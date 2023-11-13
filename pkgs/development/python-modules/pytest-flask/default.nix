{ lib
, stdenv
, buildPythonPackage
, fetchPypi
, flask
, pytest
, pytestCheckHook
, pythonOlder
, setuptools-scm
, werkzeug
}:

buildPythonPackage rec {
  pname = "pytest-flask";
  version = "1.2.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Rv3mUvd3d78C3JEgWuxM4gzfKsu71mqRirkfXBRpPT0=";
  };

  nativeBuildInputs = [
    setuptools-scm
  ];

  buildInputs = [
    pytest
  ];

  propagatedBuildInputs = [
    flask
    werkzeug
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "pytest_flask"
  ];

  pytestFlagsArray = lib.optionals stdenv.isDarwin [
    "--ignore=tests/test_live_server.py"
  ];

  meta = with lib; {
    description = "A set of pytest fixtures to test Flask applications";
    homepage = "https://pytest-flask.readthedocs.io/";
    changelog = "https://github.com/pytest-dev/pytest-flask/blob/${version}/docs/changelog.rst";
    license = licenses.mit;
    maintainers = with maintainers; [ vanschelven ];
  };
}
