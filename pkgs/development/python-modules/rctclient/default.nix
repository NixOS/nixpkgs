{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  click,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "rctclient";
  version = "0.0.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "svalouch";
    repo = "python-rctclient";
    tag = "v${finalAttrs.version}";
    hash = "sha256-f85ETzuZpOgnWpiLipLtAjOPn63yniCffWdPLyCEC3w=";
  };

  build-system = [ setuptools ];

  optional-dependencies.cli = [ click ];

  pythonImportsCheck = [ "rctclient" ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    description = "Python implementation of the RCT Power GmbH Serial Communication Protocol";
    homepage = "https://github.com/svalouch/python-rctclient";
    changelog = "https://github.com/svalouch/python-rctclient/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ _9R ];
  };
})
