{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  nix-update-script,

  pillow,
}:

buildPythonPackage (finalAttrs: {
  pname = "haishoku";
  version = "1.1.8";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "LanceGin";
    repo = "haishoku";
    tag = "v${finalAttrs.version}";
    hash = "sha256-LSoZopCaM5vbknGS9gG13OZIgghgqJvPtktUkBCH04Q=";
  };

  build-system = [ setuptools ];

  dependencies = [ pillow ];

  # no test
  doCheck = false;

  pythonImportsCheck = [ "haishoku" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Development tool for grabbing the dominant color or representative color palette from an image";
    homepage = "https://github.com/LanceGin/haishoku";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ moraxyc ];
  };
})
