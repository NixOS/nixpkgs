{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  pillow,
  tomlkit,
  pyyaml,
  rustPlatform,
}:

buildPythonPackage rec {
  pname = "oxipng-pybind";
  version = "10.1.1.post3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pdomain";
    repo = "oxipng-pybind";
    rev = "v${version}";
    hash = "sha256-6ET4bfe5hk+SS4LtvK1WfCj9Zccp/zse5la5osituAo=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname version src;
    hash = "sha256-DiM0Iwx2BJJSvOayw9FZ1ZmFX2H0TFBeaD+dxTqIqPE=";
  };

  nativeBuildInputs = with rustPlatform; [
    cargoSetupHook
    maturinBuildHook
  ];

  nativeCheckInputs = [
    rustPlatform.cargoCheckHook
    pytestCheckHook
    pillow
    tomlkit
    pyyaml
  ];

  pythonImportsCheck = [
    "oxipng"
  ];

  meta = {
    description = "Focused Python bindings for oxipng";
    homepage = "https://github.com/pdomain/oxipng-pybind";
    changelog = "https://github.com/pdomain/oxipng-pybind/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.unlicense;
    maintainers = with lib.maintainers; [ xavwe ];
  };
}
