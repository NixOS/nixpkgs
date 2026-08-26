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
  version = "0.12.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "omerbenamram";
    repo = "pyevtx-rs";
    tag = finalAttrs.version;
    hash = "sha256-pPWZOnBlHtt2xVGXYfh06GF3JyoB5wSLeZvC1gUdejk=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-D27XBfc5ZdkVKfv373NXm0W1WqZksUdmxs0FCGsx6Js=";
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
