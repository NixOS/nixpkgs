{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  pkg-config,
  rustc,
  rustPlatform,

  # tests
  numpy,
  pytestCheckHook,
  pytest-benchmark,
  pytest-rerunfailures,
}:

buildPythonPackage rec {
  pname = "gilknocker";
  version = "0.4.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "milesgranger";
    repo = "gilknocker";
    tag = "v${version}";
    hash = "sha256-RFLThZRxAXqF/Yzjpmafn2dVavOGJrM9U258FfLej/I=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname version src;
    hash = "sha256-C3rxqmZMSc6SC8bU5VB61x8Xk/crD3o7Nr1xvzv7uqI=";
  };

  nativeBuildInputs =
    with rustPlatform;
    [
      cargoSetupHook
      maturinBuildHook
    ]
    ++ [
      pkg-config
      rustc
    ];

  pythonImportsCheck = [
    "gilknocker"
  ];

  nativeCheckInputs = [
    numpy
    pytestCheckHook
    pytest-benchmark
    pytest-rerunfailures
  ];

  pytestFlags = [ "--benchmark-disable" ];

  meta = {
    description = "Knock on the Python GIL, determine how busy it is";
    homepage = "https://github.com/milesgranger/gilknocker";
    changelog = "https://github.com/milesgranger/gilknocker/releases/tag/v${version}";
    license = with lib.licenses; [
      mit
      unlicense
    ];
    maintainers = with lib.maintainers; [ daspk04 ];
  };
}
