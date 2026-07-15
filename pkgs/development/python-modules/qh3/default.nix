{
  buildPythonPackage,
  cmake,
  cryptography,
  dnspython,
  fetchFromGitHub,
  lib,
  pytest-asyncio,
  pytest-mock,
  pytestCheckHook,
  rustPlatform,
  stdenv,
}:

buildPythonPackage (finalAttrs: {
  pname = "qh3";
  version = "1.9.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jawah";
    repo = "qh3";
    tag = "v${finalAttrs.version}";
    hash = "sha256-m77m+uw6tntW+YEo0+hKZx8EePNcoivBZC84X7RDu5o=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-mQ7kRXi5dqSJ1D58rZivKVO6j3SC+9GkDZkErU21cQc=";
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
    dnspython
    pytest-asyncio
    pytest-mock
    pytestCheckHook
  ];

  __darwinAllowLocalNetworking = true;

  preCheck = ''
    # import from $out
    rm -r qh3
  '';

  disabledTests = lib.optionals stdenv.hostPlatform.isDarwin [
    # ConnectionError
    "test_connect_and_serve_ipv4"
    "test_ech_accepted"
    "test_grease_ech_no_rejection"
  ];

  meta = {
    changelog = "https://github.com/jawah/qh3/blob/${finalAttrs.src.tag}/CHANGELOG.rst";
    description = "Lightweight QUIC and HTTP/3 implementation in Python";
    homepage = "https://github.com/jawah/qh3";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
})
