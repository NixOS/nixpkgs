{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  cython,
  pkgs,
  nix-update-script,
}:

buildPythonPackage (finalAttrs: {
  pname = "cysystemd";
  version = "2.0.5";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "mosquito";
    repo = "cysystemd";
    tag = finalAttrs.version;
    hash = "sha256-4B+/RLjKjirJsJYvvXlIVNWh5XMn1n05cvuUY/+hUPo=";
  };

  postPatch = ''
    substituteInPlace cysystemd/__init__.py --replace-fail '(2, 0, 1)' '(2, 0, 5)'
  '';

  build-system = [
    setuptools
    cython
  ];

  buildInputs = with pkgs; [
    systemd
  ];

  pythonImportsCheck = [
    "cysystemd"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Systemd wrapper on Cython";
    homepage = "https://github.com/mosquito/cysystemd";
    changelog = "https://github.com/mosquito/cysystemd/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ ];
  };
})
