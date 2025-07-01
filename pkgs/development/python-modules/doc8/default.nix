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
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-EmetMnWJcfvPmRRCQXo5Nce8nlJVDnNiLg5WulXqHUA=";
  };

  build-system = [
    setuptools-scm
    wheel
  ];

  buildInputs = [ pbr ];

  dependencies = [
    docutils
    chardet
    stevedore
    restructuredtext-lint
    pygments
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "doc8" ];

  meta = {
    description = "Style checker for Sphinx (or other) RST documentation";
    mainProgram = "doc8";
    homepage = "https://github.com/pycqa/doc8";
    changelog = "https://github.com/PyCQA/doc8/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ onny ];
  };
}
