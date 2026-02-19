{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pefile,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "dnfile";
  version = "0.18.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "malwarefrank";
    repo = "dnfile";
    tag = "v${finalAttrs.version}";
    hash = "sha256-lIhhiOtMZnYziGeLUK7awJSibP3k8JCYg43jvIl5Puw=";
    fetchSubmodules = true;
  };

  build-system = [ setuptools ];

  dependencies = [ pefile ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "dnfile" ];

  meta = {
    description = "Module to parse .NET executable files";
    homepage = "https://github.com/malwarefrank/dnfile";
    changelog = "https://github.com/malwarefrank/dnfile/blob/${finalAttrs.src.tag}/HISTORY.rst";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
