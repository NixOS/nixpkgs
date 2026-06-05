{
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  pydantic,
  pytest-asyncio,
  pytestCheckHook,
  stdenv,
  lib,
}:
buildPythonPackage rec {
  pname = "essentials";
  version = "1.1.9";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Neoteroi";
    repo = "essentials";
    tag = "v${version}";
    hash = "sha256-kKAXCtcl6duVpuGDnSqVfJmfltv9ybU8Gmr3y32Dg9I=";
  };

  build-system = [ hatchling ];

  nativeCheckInputs = [
    pydantic
    pytest-asyncio
    pytestCheckHook
  ];

  disabledTests = lib.optionals stdenv.hostPlatform.isDarwin [
    # time.sleep(0.01) can be up to 0.05s on darwin
    "test_stopwatch"
    "test_stopwatch_with_context_manager"
  ];

  pythonImportsCheck = [ "essentials" ];

  meta = {
    homepage = "https://github.com/Neoteroi/essentials";
    description = "General purpose classes and functions";
    changelog = "https://github.com/Neoteroi/essentials/releases/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      aldoborrero
      zimbatm
    ];
  };
}
