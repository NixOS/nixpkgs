{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  mako,
  markdown,
  setuptools-git,
  setuptools-scm,
  unittestCheckHook,
}:

buildPythonPackage rec {
  pname = "pdoc3";
  version = "0.11.1";
  pyproject = true;
  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "pdoc3";
    repo = "pdoc";
    rev = "refs/tags/${version}";
    hash = "sha256-Opj1fU1eZvqsYJGCBliVwugxFV4H1hzOOTkjs4fOEWA=";
  };

  build-system = [
    setuptools-git
    setuptools-scm
  ];

  dependencies = [
    mako
    markdown
  ];

  pythonImportsCheck = [ "pdoc" ];

  nativeCheckInputs = [ unittestCheckHook ];

  meta = {
    changelog = "https://github.com/pdoc3/pdoc/blob/${src.rev}/CHANGELOG";
    description = "Auto-generate API documentation for Python projects";
    homepage = "https://pdoc3.github.io/pdoc/";
    license = lib.licenses.agpl3Plus;
    mainProgram = "pdoc";
    maintainers = with lib.maintainers; [ catern ];
  };
}
