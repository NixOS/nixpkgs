{
  lib,
  buildPythonPackage,
  fetchFromGitLab,
  flit-core,
  unittestCheckHook,
}:

buildPythonPackage rec {
  pname = "colored";
  version = "2.3.1";
  pyproject = true;

  src = fetchFromGitLab {
    owner = "dslackw";
    repo = "colored";
    tag = version;
    hash = "sha256-PPaPw7pCZJeBz6h5omZ+kcRXsqi6ncLYGM7FNfZ0r4w=";
  };

  nativeBuildInputs = [ flit-core ];

  nativeCheckInputs = [ unittestCheckHook ];

  unittestFlagsArray = [ "unittests" ];

  pythonImportsCheck = [ "colored" ];

  meta = {
    description = "Simple library for color and formatting to terminal";
    homepage = "https://gitlab.com/dslackw/colored";
    changelog = "https://gitlab.com/dslackw/colored/-/raw/${version}/CHANGES.md";
    maintainers = [ ];
    license = lib.licenses.mit;
  };
}
