{
  stdenv,
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  rustPlatform,
  libiconv,
}:

buildPythonPackage (finalAttrs: {
  pname = "evtx";
  version = "0.14.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "omerbenamram";
    repo = "pyevtx-rs";
    tag = finalAttrs.version;
    hash = "sha256-blWHrm16pw3dUsO987jXMS9u4eAoNThXKE1FXwqIhsM=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-LpYrbs9fwVMUHSvxRGjoct60r5Tpdy9iJtyDj9X8e/E=";
  };

  nativeBuildInputs = with rustPlatform; [
    cargoSetupHook
    maturinBuildHook
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [ libiconv ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "evtx" ];

  meta = {
    description = "Bindings for evtx";
    homepage = "https://github.com/omerbenamram/pyevtx-rs";
    changelog = "https://github.com/omerbenamram/pyevtx-rs/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
