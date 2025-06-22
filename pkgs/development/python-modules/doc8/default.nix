{
  lib,
  buildPythonPackage,
  chardet,
  docutils,
  fetchPypi,
  pbr,
  pygments,
  pytestCheckHook,
  pythonOlder,
  restructuredtext-lint,
  setuptools-scm,
  stevedore,
  wheel,
}:

buildPythonPackage rec {
  pname = "doc8";
  version = "2.0.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-EmetMnWJcfvPmRRCQXo5Nce8nlJVDnNiLg5WulXqHUA=";
  };

  nativeBuildInputs = [
    setuptools-scm
    wheel
  ];

  buildInputs = [ pbr ];

  propagatedBuildInputs = [
    docutils
    chardet
    stevedore
    restructuredtext-lint
    pygments
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonRelaxDeps = [ "docutils" ];

  pythonImportsCheck = [ "doc8" ];

  meta = with lib; {
    description = "Style checker for Sphinx (or other) RST documentation";
    mainProgram = "doc8";
    homepage = "https://github.com/pycqa/doc8";
    changelog = "https://github.com/PyCQA/doc8/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ onny ];
  };
}
