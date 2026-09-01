{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  qrcode,
  lxmf,
  rns,
  setuptools,
  versionCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "lxmf";
  version = "1.1.0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "markqvist";
    repo = "lxmf";
    tag = finalAttrs.version;
    hash = "sha256-XiBBf9eqW7BWCcRJzgQ0SrItoF9hr33u9nK6VBkSM9Y=";
  };

  build-system = [ setuptools ];

  buildInputs = [ rns ];

  dependencies = [
    qrcode
    rns
  ];

  pythonImportsCheck = [ "LXMF" ];
  nativeCheckInputs = [ versionCheckHook ];

  passthru.withoutRns = lxmf.overridePythonAttrs (old: {
    dependencies = builtins.filter (dep: dep != rns) (old.dependencies or [ ]);
    nativeCheckInputs = [];
  });

  meta = {
    description = "Lightweight Extensible Message Format for Reticulum";
    homepage = "https://github.com/markqvist/lxmf";
    changelog = "https://github.com/markqvist/LXMF/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.reticulum;
    maintainers = with lib.maintainers; [
      drupol
      fab
    ];
    mainProgram = "lxmd";
  };
})
