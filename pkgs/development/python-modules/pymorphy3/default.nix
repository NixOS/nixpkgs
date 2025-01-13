{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  click,
  dawg-python,
  pytestCheckHook,
  pymorphy3-dicts-ru,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pymorphy3";
  version = "2.0.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "no-plagiarism";
    repo = "pymorphy3";
    tag = version;
    hash = "sha256-qYZm88wNOyZBb2Qhdpw83Oh679/dkWmrL/hQYsgEsaM=";
  };

  build-system = [ setuptools ];

  dependencies = [
    dawg-python
    pymorphy3-dicts-ru
  ];

  optional-dependencies.CLI = [ click ];

  nativeCheckInputs = [ pytestCheckHook ] ++ optional-dependencies.CLI;

  pythonImportsCheck = [ "pymorphy3" ];

  meta = {
    description = "Morphological analyzer/inflection engine for Russian and Ukrainian";
    mainProgram = "pymorphy";
    homepage = "https://github.com/no-plagiarism/pymorphy3";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jboy ];
  };
}
