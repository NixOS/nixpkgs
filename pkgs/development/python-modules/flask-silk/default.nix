{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  flask,
  pytestCheckHook,
}:

buildPythonPackage {
  pname = "flask-silk";
  version = "0.2-unstable-2018-06-14";
  pyproject = true;

  # master fixes flask import syntax and has no major changes
  # new release requested: https://github.com/sublee/flask-silk/pull/6
  src = fetchFromGitHub {
    owner = "sublee";
    repo = "flask-silk";
    rev = "3a8166550f9a0ec52edae7bf31d9818c4c15c531";
    hash = "sha256-AFbGp/d+3Tci8Kj2BuT7GPdKQRBVb6PV1U6KwnH89FY=";
  };

  build-system = [ setuptools ];

  dependencies = [ flask ];

  pythonImportsCheck = [ "flask_silk" ];

  nativeCheckInputs = [ pytestCheckHook ];

  pytestFlagsArray = [ "test.py" ];

  disabledTests = [
    # requires network access
    "test_subdomain"
  ];

  meta = {
    description = "Adds silk icons to your Flask application or module, or extension";
    license = lib.licenses.bsd3;
    maintainers = lib.teams.sage.members;
    homepage = "https://github.com/sublee/flask-silk";
  };
}
