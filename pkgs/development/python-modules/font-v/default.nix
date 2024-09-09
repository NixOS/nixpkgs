{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fonttools,
  git,
  gitpython,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "font-v";
  version = "2.1.0";
  format = "setuptools";

  # PyPI source tarballs omit tests, fetch from Github instead
  src = fetchFromGitHub {
    owner = "source-foundry";
    repo = "font-v";
    rev = "v${version}";
    hash = "sha256-ceASyYcNul5aWPAPGajCQrqsQ3bN1sE+nMbCbj7f35w=";
  };

  propagatedBuildInputs = [
    fonttools
    gitpython
  ];

  doCheck = true;
  nativeCheckInputs = [
    git
    pytestCheckHook
  ];
  preCheck = ''
    # Many tests assume they are running from a git checkout, although they
    # don't care which one. Create a dummy git repo to satisfy the tests:
    git init -b main
    git config user.email test@example.invalid
    git config user.name Test
    git commit --allow-empty --message 'Dummy commit for tests'
  '';
  disabledTests = [
    # These tests assume they are actually running from a font-v git checkout,
    # so just skip them:
    "test_utilities_get_gitrootpath_function"
  ];

  meta = with lib; {
    description = "Python utility for manipulating font version headers";
    mainProgram = "font-v";
    homepage = "https://github.com/source-foundry/font-v";
    license = licenses.mit;
    maintainers = with maintainers; [ danc86 ];
  };
}
