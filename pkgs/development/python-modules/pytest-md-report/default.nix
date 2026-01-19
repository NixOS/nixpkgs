{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  setuptools-scm,
  pytablewriter,
  pytest,
  tcolorpy,
  typepy,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pytest-md-report";
  version = "0.7.0";
  pyproject = true;

  src = fetchPypi {
    pname = "pytest_md_report";
    inherit version;
    hash = "sha256-O4Mur2YLRwtXQuWNnJpeMSsHEqcBLSUcwE6QioHOPJY=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  propagatedBuildInputs = [
    pytablewriter
    tcolorpy
    typepy
  ];

  buildInputs = [ pytest ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "pytest_md_report" ];

  meta = {
    description = "Pytest plugin to make a test results report with Markdown table format";
    homepage = "https://github.com/thombashi/pytest-md-report";
    changelog = "https://github.com/thombashi/pytest-md-report/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ rrbutani ];
  };
}
