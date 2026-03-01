{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  cffi,
  setuptools,
  ukkonen,
}:

buildPythonPackage (finalAttrs: {
  pname = "identify";
  version = "2.6.16";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pre-commit";
    repo = "identify";
    tag = "v${finalAttrs.version}";
    hash = "sha256-+iLIU2NfKogFAdbAXXER3G7cDyvcey9pR+0HifQZoh8=";
  };

  build-system = [ setuptools ];

  dependencies = [
    cffi
    pytestCheckHook
    ukkonen
  ];

  pythonImportsCheck = [ "identify" ];

  meta = {
    description = "File identification library for Python";
    homepage = "https://github.com/pre-commit/identify";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "identify-cli";
  };
})
