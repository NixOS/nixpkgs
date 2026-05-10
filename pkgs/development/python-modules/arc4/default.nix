{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "arc4";
  version = "0.5.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "manicmaniac";
    repo = "arc4";
    tag = finalAttrs.version;
    hash = "sha256-kEgyZQmVdOmD/KkmEKxgZb9Hj0jGJswCJI7Np5TI1K4=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "arc4" ];

  meta = {
    description = "ARCFOUR (RC4) cipher implementation";
    homepage = "https://github.com/manicmaniac/arc4";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ fab ];
  };
})
