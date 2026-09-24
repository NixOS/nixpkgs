{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatch-vcs,
  hatchling,
  unittestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "pyotp";
  version = "2.10.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pyauth";
    repo = "pyotp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Ol7I3bj2bffKnO0r4VBOy/NvvK4pKbIul4FFlmF+wQU=";
  };

  build-system = [
    hatch-vcs
    hatchling
  ];

  nativeCheckInputs = [ unittestCheckHook ];

  pythonImportsCheck = [ "pyotp" ];

  meta = {
    changelog = "https://github.com/pyauth/pyotp/blob/v${finalAttrs.version}/Changes.rst";
    description = "Python One Time Password Library";
    homepage = "https://github.com/pyauth/pyotp";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
})
