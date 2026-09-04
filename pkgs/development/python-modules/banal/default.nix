{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  hatchling,
  pytestCheckHook,
}:
buildPythonPackage (finalAttrs: {
  pname = "banal";
  version = "1.1.2";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "pudo";
    repo = "banal";
    tag = finalAttrs.version;
    hash = "sha256-+G4zSKJangqV1RBJcuK16gAJmpPQQmPg3vEkO9HSFss=";
  };

  build-system = [ hatchling ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "banal" ];

  meta = {
    description = "Commons of banal micro-functions for Python";
    homepage = "https://github.com/pudo/banal";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
})
