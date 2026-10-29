{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  serialx,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "pyblackbird";
  version = "0.10";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "koolsb";
    repo = "pyblackbird";
    tag = finalAttrs.version;
    hash = "sha256-0XkHSRLHKAaem9qMr4Qac1YA2txci/SDgA0kfXMeiM0=";
  };

  build-system = [ setuptools ];

  dependencies = [ serialx ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "pyblackbird" ];

  meta = {
    description = "Python implementation for Monoprice Blackbird units";
    homepage = "https://github.com/koolsb/pyblackbird";
    changelog = "https://github.com/koolsb/pyblackbird/releases/tag/${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
