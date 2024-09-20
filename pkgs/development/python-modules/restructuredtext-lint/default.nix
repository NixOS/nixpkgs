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
  version = "1.4.0";
  pyproject = true;

  src = fetchPypi {
    pname = "restructuredtext_lint";
    inherit version;
    hash = "sha256-GyNcDJIjQatsUwOQiS656S+QubdQRgY+BHys+w8FDEU=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [ docutils ];

  nativeCheckInputs = [ pytestCheckHook ];

  pytestFlagsArray = [ "restructuredtext_lint/test/test.py" ];

  pythonImportsCheck = [ "restructuredtext_lint" ];

  meta = {
    description = "reStructuredText linter";
    homepage = "https://github.com/twolfson/restructuredtext-lint";
    changelog = "https://github.com/twolfson/restructuredtext-lint/blob/${version}/CHANGELOG.rst";
    license = lib.licenses.unlicense;
    mainProgram = "rst-lint";
  };
}
