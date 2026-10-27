{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  mako,
  markdown,
  setuptools-scm,
  unittestCheckHook,
}:

buildPythonPackage rec {
  pname = "pdoc3";
  version = "0.11.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pdoc3";
    repo = "pdoc";
    tag = version;
    hash = "sha256-I8EPsjwA9dHOLvM2Oa4dbtB0N4dVczeGfzk+BVyfBcQ=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail "'setuptools_git'," ""
  '';

  build-system = [
    setuptools-scm
  ];

  dependencies = [
    mako
    markdown
  ];

  pythonImportsCheck = [ "pdoc" ];

  nativeCheckInputs = [ unittestCheckHook ];

  meta = {
    changelog = "https://github.com/pdoc3/pdoc/blob/${src.tag}/CHANGELOG";
    description = "Auto-generate API documentation for Python projects";
    homepage = "https://pdoc3.github.io/pdoc/";
    license = lib.licenses.agpl3Plus;
    mainProgram = "pdoc";
  };
}
