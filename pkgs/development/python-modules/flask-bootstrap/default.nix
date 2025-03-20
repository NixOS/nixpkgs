{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  flask,
  visitor,
  dominate,
  pytestCheckHook,
  requests,
}:

buildPythonPackage rec {
  pname = "flask-bootstrap";
  version = "3.3.7.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mbr";
    repo = "flask-bootstrap";
    tag = version;
    hash = "sha256-TsRSNhrI1jZU/beX3G7LM64IrFagD6AYiluoGzy12jE=";
  };

  build-system = [ setuptools ];

  dependencies = [
    flask
    visitor
    dominate
  ];

  pythonImportsCheck = [ "flask_bootstrap" ];

  nativeCheckInputs = [
    pytestCheckHook
    requests
  ];

  disabledTests = [
    # requires network access
    "test_bootstrap_version_matches"
    # requires flask-appconfig
    "test_index"
  ];

  meta = {
    homepage = "https://github.com/mbr/flask-bootstrap";
    description = "Ready-to-use Twitter-bootstrap for use in Flask";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
}
