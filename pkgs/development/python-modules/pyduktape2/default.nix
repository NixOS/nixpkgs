{
  lib,
  buildPythonPackage,
  cython,
  fetchFromGitHub,
  nix-update-script,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "pyduktape2";
  version = "0.5.0";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "phith0n";
    repo = "pyduktape2";
    tag = finalAttrs.version;
    hash = "sha256-bRslal156vxCP0vyDK/FdqY/Bx9++4aoXXieIGI3x14=";
  };

  build-system = [
    cython
    setuptools
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "pyduktape2" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Embed the Duktape JS interpreter in Python";
    homepage = "https://github.com/phith0n/pyduktape2";
    changelog = "https://github.com/phith0n/pyduktape2/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ fab ];
  };
})
