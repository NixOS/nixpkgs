{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
  nix-update-script,
}:

buildPythonPackage (finalAttrs: {
  pname = "dowhen";
  version = "0.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "gaogaotiantian";
    repo = "dowhen";
    tag = finalAttrs.version;
    hash = "sha256-7eoNe9SvE39J4mwIOxvbU1oh/L7tr/QM1uuBDqWtQu0=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "dowhen" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Intuitive and low-overhead instrumentation tool for Python";
    homepage = "https://github.com/gaogaotiantian/dowhen";
    changelog = "https://github.com/gaogaotiantian/dowhen/releases/tag/${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ moraxyc ];
  };
})
