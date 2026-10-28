{
  lib,
  buildPythonPackage,
  cython,
  editdistpy,
  fetchFromGitHub,
  numpy,
  pkg-resources-backport,
  pytestCheckHook,
  setuptools,
  symspellpy,
}:

buildPythonPackage (finalAttrs: {
  pname = "editdistpy";
  version = "0.1.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mammothb";
    repo = "editdistpy";
    tag = "v${finalAttrs.version}";
    hash = "sha256-bUdwhMFDIhHuIlcqIZt6mSh8xwW/2igw0QiWGvQBLC8=";
  };

  build-system = [
    cython
    pkg-resources-backport
    setuptools
  ];

  nativeCheckInputs = [
    pytestCheckHook
    symspellpy
    numpy
  ];

  preCheck = ''
    rm -r editdistpy
  '';

  # error: infinite recursion encountered
  doCheck = false;

  passthru.tests = {
    check = editdistpy.overridePythonAttrs (_: {
      doCheck = true;
    });
  };

  pythonImportsCheck = [ "editdistpy" ];

  meta = {
    description = "Fast Levenshtein and Damerau optimal string alignment algorithms";
    homepage = "https://github.com/mammothb/editdistpy";
    changelog = "https://github.com/mammothb/editdistpy/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ vizid ];
  };
})
