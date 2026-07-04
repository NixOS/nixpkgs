{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  docutils,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "restructuredtext-lint";
  version = "2.0.2";
  pyproject = true;

  src = fetchPypi {
    pname = "restructuredtext_lint";
    inherit version;
    hash = "sha256-3SUgm54Lcmkp2DBjOfr3I3NKMTfbOCvPJylPoYprxSs=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [ docutils ];

  nativeCheckInputs = [ pytestCheckHook ];

  enabledTestPaths = [ "restructuredtext_lint/test/test.py" ];

  pythonImportsCheck = [ "restructuredtext_lint" ];

  meta = {
    description = "reStructuredText linter";
    homepage = "https://github.com/twolfson/restructuredtext-lint";
    changelog = "https://github.com/twolfson/restructuredtext-lint/blob/${version}/CHANGELOG.rst";
    license = lib.licenses.unlicense;
    mainProgram = "rst-lint";
  };
}
