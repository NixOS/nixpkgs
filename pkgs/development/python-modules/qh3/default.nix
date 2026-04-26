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

buildPythonPackage rec {
  pname = "qh3";
  version = "1.7.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jawah";
    repo = "qh3";
    tag = "v${version}";
    hash = "sha256-wi2PYd74kOU2tol7pVgpMqbL3peGhXyKKEke6+CBIwU=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname version src;
    hash = "sha256-sv5DFeapeH00CBssQcRZ7SI3JlyUuKo7gIRVjN/kA+Q=";
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
    changelog = "https://github.com/jawah/qh3/blob/${src.tag}/CHANGELOG.rst";
    description = "Lightweight QUIC and HTTP/3 implementation in Python";
    homepage = "https://github.com/jawah/qh3";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
