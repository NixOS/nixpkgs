{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  flit-core,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "editables";
  version = "0.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pfmoore";
    repo = "editables";
    tag = finalAttrs.version;
    hash = "sha256-U2IH1Bzu0k+hvNH6b3eT2W23BxfBeqOzNyp1Ig0bnOY=";
  };

  build-system = [ flit-core ];

  nativeCheckInputs = [ pytestCheckHook ];

  # Infinite recursion
  doCheck = false;

  pythonImportsCheck = [ "editables" ];

  meta = {
    description = "Editable installations";
    homepage = "https://github.com/pfmoore/editables";
    changelog = "https://github.com/pfmoore/editables/blob/${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ getchoo ];
  };
})
