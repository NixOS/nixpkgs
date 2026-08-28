{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "patch-ng";
  version = "1.19.1"; # note: `conan` package may require a hardcoded one
  pyproject = true;

  src = fetchFromGitHub {
    owner = "conan-io";
    repo = "python-patch-ng";
    tag = finalAttrs.version;
    hash = "sha256-X/OujL/zEZ5KkijFY6vgfUs/L1pslIfAl6TcAaTjA6U=";
  };

  build-system = [ setuptools ];

  pythonImportsCheck = [ "patch_ng" ];

  meta = {
    description = "Library to parse and apply unified diffs";
    homepage = "https://github.com/conan-io/python-patch-ng";
    changelog = "https://github.com/conan-io/python-patch-ng/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
})
