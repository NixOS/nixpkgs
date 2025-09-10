{
  lib,
  stdenv,
  buildPythonPackage,
  fetchPypi,
  flask,
  pytest,
  pytestCheckHook,
  pythonOlder,
  setuptools-scm,
  werkzeug,
}:

buildPythonPackage rec {
  pname = "pytest-flask";
  version = "1.3.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-WL4cl7Ibo8TUfgp2ketBAHdIUGw2v1EAT3jfEGkfqV4=";
  };

  nativeBuildInputs = [ setuptools-scm ];

  buildInputs = [ pytest ];

  propagatedBuildInputs = [
    flask
    werkzeug
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "pytest_flask" ];

  disabledTestPaths = lib.optionals stdenv.hostPlatform.isDarwin [
    "tests/test_live_server.py"
  ];

  meta = with lib; {
    description = "Set of pytest fixtures to test Flask applications";
    homepage = "https://pytest-flask.readthedocs.io/";
    changelog = "https://github.com/pytest-dev/pytest-flask/blob/${version}/docs/changelog.rst";
    license = licenses.mit;
    maintainers = with maintainers; [ vanschelven ];
  };
}
