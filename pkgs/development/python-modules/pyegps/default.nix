{
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  pytestCheckHook,
  pyusb,
  setuptools,
  setuptools-scm,
}:

buildPythonPackage (finalAttrs: {
  pname = "pyegps";
  version = "0.2.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "gnumpi";
    repo = "pyegps";
    tag = "v${finalAttrs.version}";
    hash = "sha256-iixk2sFa4KAayKFmQKtPjvoIYgxCMXnfkliKhyO2ba4=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [ pyusb ];

  pythonImportsCheck = [ "pyegps" ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    changelog = "https://github.com/gnumpi/pyEGPS/releases/tag/v${finalAttrs.version}";
    description = "Controlling Energenie Power Strips with python";
    homepage = "https://github.com/gnumpi/pyegps";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
})
