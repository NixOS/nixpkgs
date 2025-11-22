{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  pythonOlder,

  setuptools,

  unittestCheckHook,
}:

buildPythonPackage {
  pname = "lorem";
  version = "0.1.1";
  disabled = pythonOlder "3.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "sfischer13";
    repo = "python-lorem";
    # no tags in github
    rev = "abf0d5b6708ea5d84fbbf46bef74907e3a7517f2";
    hash = "sha256-fPkgNeADa5LvmEebVbJ+Rtfda9kodwvqTzbQsH26ILA=";
  };

  build-system = [ setuptools ];

  pythonImportsCheck = [ "lorem" ];
  nativeCheckInputs = [ unittestCheckHook ];

  meta = {
    description = "Python library for the generation of random text that looks like Latin";
    homepage = "https://github.com/sfischer13/python-lorem";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      jk
    ];
  };
}
