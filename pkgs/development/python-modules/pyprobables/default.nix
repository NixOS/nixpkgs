{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "pyprobables";
  version = "0.7.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "barrust";
    repo = "pyprobables";
    tag = "v${finalAttrs.version}";
    hash = "sha256-wUeNmkDzDBXGtMBplS2Hv6rK+M3eijVpYtHMhjIpsy8=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "probables" ];

  meta = {
    description = "Probabilistic data structures";
    homepage = "https://github.com/barrust/pyprobables";
    changelog = "https://github.com/barrust/pyprobables/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
