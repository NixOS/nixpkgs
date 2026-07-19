{
  buildPythonPackage,
  fetchFromGitHub,
  hatch-vcs,
  hatchling,
  lib,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "inject";
  version = "5.5.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ivankorobkov";
    repo = "python-inject";
    tag = "v${finalAttrs.version}";
    hash = "sha256-F2YzzcMFmhurTcP1ETvJIfsFHUpPyi0mubGws2YYpok=";
  };

  build-system = [
    hatchling
    hatch-vcs
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "inject" ];

  meta = {
    description = "Python dependency injection framework";
    homepage = "https://github.com/ivankorobkov/python-inject";
    changelog = "https://github.com/ivankorobkov/python-inject/blob/${finalAttrs.src.tag}/CHANGES.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ PerchunPak ];
  };
})
