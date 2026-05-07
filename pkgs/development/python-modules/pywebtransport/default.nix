{
  lib,
  buildPythonPackage,
  clang,
  fetchFromGitHub,
  libclang,
  llvmPackages,
  msgpack,
  pkg-config,
  protobuf,
  psutil,
  pytest-asyncio,
  pytest-cov-stub,
  pytest-mock,
  pytestCheckHook,
  rustPlatform,
  types-psutil,
  uvloop,
}:

buildPythonPackage (finalAttrs: {
  pname = "pywebtransport";
  version = "0.16.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "wtransport";
    repo = "pywebtransport";
    tag = "v${finalAttrs.version}";
    hash = "sha256-DKvWSu2ufoIsBODNfFbM9JUtY81mmUISmD+qMQ6UVDI=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    cargoRoot = "crates";
    hash = "sha256-gplelmBqntws+64DmjOZ5xbo3L/f+3+oasi5qLXT1pg=";
  };

  build-system = with rustPlatform; [
    cargoSetupHook
    maturinBuildHook
  ];

  nativeBuildInputs = [
    clang
    llvmPackages.libclang.lib
    pkg-config
  ];

  env.LIBCLANG_PATH = "${llvmPackages.libclang.lib}/lib";
  env.LD_LIBRARY_PATH = "${llvmPackages.libclang.lib}/lib:${lib.getLib libclang}/lib";

  prePatch = ''
    # maturin can't find the file
    ln -s crates/Cargo.lock Cargo.lock || true
  '';

  optional-dependencies = {
    msgpack = [ msgpack ];
    protobuf = [ protobuf ];
  };

  nativeCheckInputs = [
    psutil
    pytest-asyncio
    pytest-cov-stub
    pytest-mock
    pytestCheckHook
    types-psutil
    uvloop
  ]
  ++ lib.flatten (builtins.attrValues finalAttrs.passthru.optional-dependencies);

  disabledTestPaths = [
    # Tests require network access
    "tests/e2e"
  ];

  preCheck = ''
    cp -v $out/lib/python*/site-packages/pywebtransport/_wtransport*.so src/pywebtransport/
  '';

  pythonImportsCheck = [ "pywebtransport" ];

  meta = {
    description = "WebTransport stack for Python";
    homepage = "https://github.com/wtransport/pywebtransport";
    changelog = "https://github.com/wtransport/pywebtransport/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
})
