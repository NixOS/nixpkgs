{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  mypy,
  pathspec,
  setuptools,
  build,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "hatch-mypyc";
  version = "0.16.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ofek";
    repo = "hatch-mypyc";
    rev = "v${finalAttrs.version}";
    hash = "sha256-3bIi2tlAcBurWqqPDVTJ1/EU2KTd1XVU97jFOaYtW5U=";
  };

  build-system = [
    hatchling
  ];

  dependencies = [
    hatchling
    mypy
    pathspec
    setuptools
  ];

  doCheck = false; # network access

  pythonImportsCheck = [
    "hatch_mypyc"
  ];

  meta = {
    description = "Hatch build hook plugin for Mypyc";
    homepage = "https://github.com/ofek/hatch-mypyc";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
})
