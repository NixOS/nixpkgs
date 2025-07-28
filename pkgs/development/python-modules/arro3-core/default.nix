{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  rustPlatform,
  geoarrow-types,
  pyarrow,
  numpy,
  pandas,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "arro3-core";
  version = "0.5.1";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "kylebarron";
    repo = "arro3";
    tag = "py-v${version}";
    hash = "sha256-RTr+mf5slfxxvXp9cwPuy08AZUswPtIIRz+vngdg/k0=";
  };

  sourceRoot = "${src.name}/arro3-core";

  cargoRoot = "..";

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit version src;
    pname = "${pname}-vendor";
    hash = "sha256-YQA8Z86Ul8yAHncMgYrGmNe10KSpubHjaokCjaqTAxo=";
  };

  nativeBuildInputs = with rustPlatform; [
    cargoSetupHook
    maturinBuildHook
  ];

  env = {
    CARGO_TARGET_DIR = "./target";
  };

  nativeCheckInputs = [
    pytestCheckHook
    geoarrow-types
    pandas
    pyarrow
    numpy
  ];

  enabledTestPaths = [
    "../tests/core"
  ];

  disabledTestPaths = [
    # arro3-compute dependency has not been packaged
    "../tests/core/test_buffer_protocol.py"
  ];

  pythonImportsCheck = [ "arro3.core" ];

  meta = {
    description = "Minimal Python library for Apache Arrow, connecting to the Rust arrow crate";
    homepage = "https://github.com/kylebarron/arro3";
    changelog = "https://github.com/kylebarron/arro3/releases/tag/py-v${version}";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.mslingsby ];
  };
}
