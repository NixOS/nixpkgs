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
  version = "0.4.1.post6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "milesgranger";
    repo = "gilknocker";
    tag = "v${version}";
    hash = "sha256-jJOI7hlm6kcqfBbM56y5mKD+lJe0g+qAQpDF7ePM+GM=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname version src;
    hash = "sha256-cUv0CT8d6Nxjzh/S/hY9jcpeFX/5KvBxSkqOkt4htyU=";
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
