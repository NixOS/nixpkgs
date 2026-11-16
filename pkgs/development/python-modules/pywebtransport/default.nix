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
  version = "0.22.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "wtransport";
    repo = "pywebtransport";
    tag = "v${finalAttrs.version}";
    hash = "sha256-IdN0g/G6lwlJK89aHxz0+UmPPXWZLqKqg6u/ZmKulTc=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    cargoRoot = "crates";
    hash = "sha256-CpL2evzogq1OtoGMFoVZqi+7qDB2HBkfWcOxR4x21Yc=";
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
