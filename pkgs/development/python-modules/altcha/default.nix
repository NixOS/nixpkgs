{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "altcha";
  version = "2.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "altcha-org";
    repo = "altcha-lib-py";
    tag = "v${finalAttrs.version}";
    hash = "sha256-k5vy6lalC3idiquXbDCwF+mObzja/QC3PRBGQJMZ6fA=";
  };

  build-system = [ setuptools ];

  pythonImportsCheck = [ "altcha" ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    description = "Lightweight Python library for creating and verifying ALTCHA challenges";
    homepage = "https://github.com/altcha-org/altcha-lib-py";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ erictapen ];
  };
})
