{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  nix-update-script,
  pyasn1,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "pyasn1-alt-modules";
  version = "0.4.10";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "russhousley";
    repo = "pyasn1-alt-modules";
    tag = finalAttrs.version;
    hash = "sha256-LOD7gXv+CagAR8qzmkKEWtVFd1zZdpyC++xoU1P3HaY=";
  };

  build-system = [ setuptools ];

  dependencies = [ pyasn1 ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "pyasn1_alt_modules" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Alternative ASN.1 modules for pyasn1";
    homepage = "https://github.com/russhousley/pyasn1-alt-modules";
    changelog = "https://github.com/russhousley/pyasn1-alt-modules/blob/${finalAttrs.src.rev}/CHANGES.txt";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ fab ];
  };
})
