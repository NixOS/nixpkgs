{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "parsy";
  version = "2.2";
  pyproject = true;

  src = fetchFromGitHub {
    repo = "parsy";
    owner = "python-parsy";
    tag = "v${finalAttrs.version}";
    hash = "sha256-EzIpKlT0Yvh0XWP6tb24tvuOe4BH8KuwJ5WCUzAM8mY=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "parsy" ];

  meta = {
    homepage = "https://github.com/python-parsy/parsy";
    description = "Easy-to-use parser combinators, for parsing in pure Python";
    changelog = "https://github.com/python-parsy/parsy/blob/${finalAttrs.src.tag}/docs/history.rst";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ milibopp ];
  };
})
