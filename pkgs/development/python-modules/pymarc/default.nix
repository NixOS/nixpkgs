{
  lib,
  buildPythonPackage,
  fetchFromGitLab,
  hatchling,
  nix-update-script,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "pymarc";
  version = "5.4.0";
  pyproject = true;

  src = fetchFromGitLab {
    owner = "pymarc";
    repo = "pymarc";
    tag = "v${finalAttrs.version}";
    hash = "sha256-SLJ9QgUqyOUsmk8bOI5Hcvc3W4VLB5/zWYZUokeTniM=";
  };

  build-system = [ hatchling ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "pymarc" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Read, write and modify MARC bibliographic data";
    homepage = "https://gitlab.com/pymarc/pymarc";
    changelog = "https://gitlab.com/pymarc/pymarc/-/releases/${finalAttrs.src.tag}";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ imkarrer ];
  };
})
