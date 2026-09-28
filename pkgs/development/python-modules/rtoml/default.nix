{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  rustPlatform,

  # tests
  dirty-equals,
  pytest-benchmark,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "rtoml";
  version = "0.13";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "samuelcolvin";
    repo = "rtoml";
    tag = "v${finalAttrs.version}";
    hash = "sha256-QrGoMxNGKQS0En2txZq+mxxWpzwLbHRxqdsAZ1J/bcc=";
  };

  # The `generate-import-lib` PyO3 feature only matters when building Windows import libraries;
  # on other platforms it just pulls in the `python3-dll-a` crate, which is not vendored.
  # Drop it so the offline maturin build resolves.
  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail ', "pyo3/generate-import-lib"' ""
  '';

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-qHd82jdOyaIqVFFt+ZrHIH0EPwlLJpCFCrx15DN5Rig=";
  };

  nativeBuildInputs = with rustPlatform; [
    cargoSetupHook
    maturinBuildHook
  ];

  pythonImportsCheck = [ "rtoml" ];

  nativeCheckInputs = [
    dirty-equals
    pytest-benchmark
    pytestCheckHook
  ];

  pytestFlags = [ "--benchmark-disable" ];

  meta = {
    description = "Rust based TOML library for Python";
    homepage = "https://github.com/samuelcolvin/rtoml";
    changelog = "https://github.com/samuelcolvin/rtoml/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
})
