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
  version = "5.4.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ivankorobkov";
    repo = "python-inject";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ITnqTGCOPLzATisAcPi52cpxsm9/Adj/Xb53jd18IWo=";
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
