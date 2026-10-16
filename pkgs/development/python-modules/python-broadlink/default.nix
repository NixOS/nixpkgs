{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  cryptography,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "python-broadlink";
  version = "1.0.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "DAB-LABS";
    repo = "python-broadlink";
    tag = "v${finalAttrs.version}";
    hash = "sha256-d9ylgwumvOOLWVtMYMd38TTYFgH8ljaqbwZsjPwMBJ8=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    cryptography
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "broadlink"
  ];

  __structuredAttrs = true;

  meta = {
    description = "Python module for controlling Broadlink RM2/3 (Pro) remote controls, A1 sensor platforms and SP2/3 smartplugs";
    homepage = "https://github.com/DAB-LABS/python-broadlink";
    changelog = "https://github.com/DAB-LABS/python-broadlink/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
