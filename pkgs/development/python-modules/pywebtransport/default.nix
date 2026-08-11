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
  version = "0.20.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "wtransport";
    repo = "pywebtransport";
    tag = "v${finalAttrs.version}";
    hash = "sha256-sgD5+yk6QpNVBXGfELavYNl9E0rBuk6TTH8BDwKzEng=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    cargoRoot = "crates";
    hash = "sha256-JgnXV1hRDvXJdIWYxFACsL4dNpyAnperTJZOQS2UT5A=";
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
