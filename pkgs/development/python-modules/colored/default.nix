{
  lib,
  buildPythonPackage,
  fetchFromGitLab,
  flit-core,
  unittestCheckHook,
}:

buildPythonPackage rec {
  pname = "colored";
  version = "2.2.3";
  format = "pyproject";

  src = fetchFromGitLab {
    owner = "dslackw";
    repo = "colored";
    rev = "refs/tags/${version}";
    hash = "sha256-4APFAIN+cmPPd6qbqVC9iU4YntNEjoPbJXZywG1hsBY=";
  };

  nativeBuildInputs = [ flit-core ];

  nativeCheckInputs = [ unittestCheckHook ];

  unittestFlagsArray = [ "unittests" ];

  pythonImportsCheck = [ "colored" ];

  meta = with lib; {
    description = "Simple library for color and formatting to terminal";
    homepage = "https://gitlab.com/dslackw/colored";
    changelog = "https://gitlab.com/dslackw/colored/-/raw/${version}/CHANGES.md";
    maintainers = with maintainers; [ ];
    license = licenses.mit;
  };
}
