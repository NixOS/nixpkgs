{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pydantic,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "packageurl-python";
  version = "0.17.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "package-url";
    repo = "packageurl-python";
    tag = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-jH4zJN3XGPFBnto26pcvADXogpooj3dqpqkWnKXgICY=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [
    pydantic
    pytestCheckHook
  ];

  pythonImportsCheck = [ "packageurl" ];

  meta = {
    description = "Python parser and builder for package URLs";
    homepage = "https://github.com/package-url/packageurl-python";
    changelog = "https://github.com/package-url/packageurl-python/blob/${finalAttrs.src.tag}/CHANGELOG.rst";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ armijnhemel ];
  };
})
