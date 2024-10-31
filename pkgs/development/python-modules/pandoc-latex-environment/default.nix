{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  poetry-dynamic-versioning,
  panflute,
  pytestCheckHook,
  pandoc,
}:

buildPythonPackage rec {
  pname = "pandoc-latex-environment";
  version = "1.1.7.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "chdemko";
    repo = "pandoc-latex-environment";
    rev = "refs/tags/${version}";
    hash = "sha256-iKzveVTScqF8dAGPx7JU66Z5oyoZ82t101z5xeiHYqw=";
  };

  build-system = [
    poetry-core
    poetry-dynamic-versioning
  ];
  dependencies = [ panflute ];

  pythonImportsCheck = [ "pandoc_latex_environment" ];
  nativeCheckInputs = [
    pytestCheckHook
    pandoc
  ];

  meta = {
    description = "Pandoc filter for adding LaTeX environment on specific div";
    homepage = "https://github.com/chdemko/pandoc-latex-environment";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ sigmanificient ];
  };
}
