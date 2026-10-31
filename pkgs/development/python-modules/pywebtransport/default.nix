{
  lib,
  buildPythonPackage,
  clang,
  fetchFromGitHub,
  llvmPackages,
  pkg-config,
  pytest-asyncio,
  pytest-cov-stub,
  pytest-mock,
  pytestCheckHook,
  rustPlatform,
}:

buildPythonPackage (finalAttrs: {
  pname = "pywebtransport";
  version = "0.21.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "wtransport";
    repo = "pywebtransport";
    tag = "v${finalAttrs.version}";
    hash = "sha256-VHkQffB9LC9/GJGMHfSrGixXtmAgEROUVgQexCWGvMY=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    cargoRoot = "crates";
    hash = "sha256-WfSiNZZFTYSUh5wR1yBfb0SAmngqt/XbtgH9Ycpe+wA=";
  };

  build-system = with rustPlatform; [
    cargoSetupHook
    maturinBuildHook
  ];

  nativeBuildInputs = [
    llvmPackages.clang
    llvmPackages.libclang.lib
    pkg-config
  ];

  env.LIBCLANG_PATH = "${llvmPackages.libclang.lib}/lib";
  env.LD_LIBRARY_PATH = "${llvmPackages.libclang.lib}/lib:${lib.getLib clang}/lib";

  prePatch = ''
    # maturin can't find the file
    ln -s crates/Cargo.lock Cargo.lock || true
  '';

  nativeCheckInputs = [
    pytest-asyncio
    pytest-cov-stub
    pytest-mock
    pytestCheckHook
  ];

  preCheck = ''
    cp -v $out/lib/python*/site-packages/pywebtransport/_pywebtransport*.so src/pywebtransport/
  '';

  pythonImportsCheck = [ "pywebtransport" ];

  meta = {
    description = "Async-native WebTransport stack";
    homepage = "https://github.com/wtransport/pywebtransport";
    changelog = "https://github.com/wtransport/pywebtransport/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
})
