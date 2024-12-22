{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  pytestCheckHook,

  pythonOlder,

  setuptools,
  cython,

  symspellpy,
  numpy,
  editdistpy,
}:

buildPythonPackage rec {
  pname = "editdistpy";
  version = "0.1.5";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "mammothb";
    repo = "editdistpy";
    rev = "refs/tags/v${version}";
    hash = "sha256-kTaJkx1fdd2Rl4uhzxdZAFP/ArsM0qTPweJ1jlUcjxQ=";
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

  meta = with lib; {
    description = "Fast Levenshtein and Damerau optimal string alignment algorithms";
    homepage = "https://github.com/mammothb/editdistpy";
    changelog = "https://github.com/mammothb/editdistpy/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ vizid ];
  };
}
