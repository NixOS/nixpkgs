{
  lib,
  buildPythonPackage,
  fetchPypi,
  # rns optionally depends on lxmf but we can't have two versions of rns in a closure
  propagateRns ? false,
  qrcode,
  rns,
  setuptools,
  versionCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "lxmf";
  version = "1.3.1";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) version;
    pname = "lxmf";
    hash = "sha256-905ygZepWZofaUywV7gvbIlr8g3thhPusbFn3wK7GZ8=";
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
    changelog = "https://github.com/markqvist/LXMF/releases/tag/${finalAttrs.version}";
    license = lib.licenses.reticulum;
    maintainers = with lib.maintainers; [
      drupol
      fab
    ];
    mainProgram = "lxmd";
  };
})
