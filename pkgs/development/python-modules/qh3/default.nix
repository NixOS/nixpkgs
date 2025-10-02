{
  buildPythonPackage,
  cmake,
  cryptography,
  fetchFromGitHub,
  lib,
  pytest-asyncio,
  pytest-mock,
  pytestCheckHook,
  rustPlatform,
  stdenv,
}:

buildPythonPackage rec {
  pname = "qh3";
  version = "1.5.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jawah";
    repo = "qh3";
    tag = "v${version}";
    hash = "sha256-VlqkZk+7803dzwMBFpsSSQUSVu5/1jKouwuK7jNuMGU=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname version src;
    hash = "sha256-Dgx7CSH+XyVZSVHAcr65QULsY//rxgeQe5jYQQkSjHc=";
  };

  nativeBuildInputs = [
    cmake
    rustPlatform.bindgenHook
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
  ];

  dontUseCmakeConfigure = true;

  env.NIX_CFLAGS_COMPILE = toString (
    lib.optionals stdenv.cc.isGNU [
      "-Wno-error=stringop-overflow"
    ]
  );

  pythonImportsCheck = [ "qh3" ];

  nativeCheckInputs = [
    cryptography
    pytest-asyncio
    pytest-mock
    pytestCheckHook
  ];

  __darwinAllowLocalNetworking = true;

  preCheck = ''
    # import from $out
    rm -r qh3
  '';

  disabledTests = lib.optionals stdenv.buildPlatform.isDarwin [
    # ConnectionError
    "test_connect_and_serve_ipv4"
  ];

  meta = {
    changelog = "https://github.com/jawah/qh3/blob/${src.tag}/CHANGELOG.rst";
    description = "Lightweight QUIC and HTTP/3 implementation in Python";
    homepage = "https://github.com/jawah/qh3";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
