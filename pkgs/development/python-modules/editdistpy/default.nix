{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  pytestCheckHook,

  setuptools,
  cython,

  symspellpy,
  numpy,
  editdistpy,
}:

buildPythonPackage rec {
  pname = "editdistpy";
  version = "0.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mammothb";
    repo = "editdistpy";
    tag = "v${version}";
    hash = "sha256-lJ370X8JWzJWJzZc2mPZkWOWONDRwm/pGKAL2vGpBLw=";
  };

  build-system = [
    setuptools
    cython
  ];

  # error: infinite recursion encountered
  doCheck = false;

  nativeCheckInputs = [
    pytestCheckHook
    symspellpy
    numpy
  ];

  preCheck = ''
    rm -r editdistpy
  '';

  passthru.tests = {
    check = editdistpy.overridePythonAttrs (_: {
      doCheck = true;
    });
  };

  pythonImportsCheck = [ "editdistpy" ];

  meta = {
    description = "Fast Levenshtein and Damerau optimal string alignment algorithms";
    homepage = "https://github.com/mammothb/editdistpy";
    changelog = "https://github.com/mammothb/editdistpy/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ vizid ];
  };
}
