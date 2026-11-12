{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch2,
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

  patches = [
    (fetchpatch2 {
      name = "fix-setext-headers-with-markdown-3.10.3.patch";
      url = "https://github.com/pdoc3/pdoc/commit/2aaba16a50be488f2939e98dc9b0c0a995c262a3.patch?full_index=1";
      hash = "sha256-y5ja7qini/qcllMVWfw/iOtkMogFKX+5owVgoIGBNlQ=";
    })
  ];

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
