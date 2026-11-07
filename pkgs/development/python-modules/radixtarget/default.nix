{
  lib,
  buildPythonPackage,
  cargo,
  fetchPypi,
  nix-update-script,
  poetry-core,
  pytestCheckHook,
  rustc,
  rustPlatform,
}:

buildPythonPackage (finalAttrs: {
  pname = "radixtarget";
  version = "4.3.0";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-uHmznv6XpjmeejmG8lnZKMDxfl9hZES3quFYn89BO3E=";
  };

  postUnpack = ''
    rm -f "$sourceRoot/dist/"*.whl
  '';

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-FIkZm4bgkBNOT4n3X9uKfdkYQZiuxPXBl/rpcX/wH/o=";
  };

  build-system = [
    cargo
    poetry-core
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
    rustc
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  preCheck = ''
    cp -r radixtarget/test ./
    rm -rf radixtarget
  '';

  pytestFlags = [ "test" ];

  pythonImportsCheck = [ "radixtarget" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Fast radix tree for IP addresses and DNS names";
    homepage = "https://pypi.org/project/radixtarget";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ fab ];
  };
})
