{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  # rns optionally depends on lxmf but we can't have two versions of rns in a closure
  propagateRns ? false,
  qrcode,
  rns,
  setuptools,
  versionCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "lxmf";
  version = "1.0.1";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "markqvist";
    repo = "lxmf";
    tag = finalAttrs.version;
    hash = "sha256-Lx7eG7idbqjJrOE15/OJ8kh++4STQHxNVMTRVXdAEYE=";
  };

  build-system = [ setuptools ];

  buildInputs = lib.optionals (!propagateRns) [
    rns
  ];

  dependencies = [
    qrcode
  ]
  ++ lib.optionals propagateRns [
    rns
  ];

  pythonImportsCheck = [ "LXMF" ];

  nativeCheckInputs = lib.optionals propagateRns [
    versionCheckHook
  ];

  meta = {
    description = "Lightweight Extensible Message Format for Reticulum";
    homepage = "https://github.com/markqvist/lxmf";
    changelog = "https://github.com/markqvist/LXMF/releases/tag/${finalAttrs.src.tag}";
    # Reticulum License
    # https://github.com/markqvist/LXMF/blob/master/LICENSE
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [
      drupol
      fab
    ];
    mainProgram = "lxmd";
  };
})
