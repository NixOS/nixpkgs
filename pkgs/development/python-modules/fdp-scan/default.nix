{
  lib,
  buildPythonPackage,
  rustPlatform,
  protobuf,
  pytestCheckHook,
  reproto,
}:

buildPythonPackage {
  pname = "fdp-scan";
  inherit (reproto) src version cargoDeps;
  pyproject = true;
  __structuredAttrs = true;

  # nixpkgs-update: no auto update
  # Built from reproto's source, at its version, with its vendored crates:
  # reproto needs all four of these libraries at exactly its version, so
  # they move with it, in reproto's update.

  buildAndTestSubdir = "fdp-scan-pyo3";

  nativeBuildInputs = [ rustPlatform.cargoSetupHook ];

  build-system = [ rustPlatform.maturinBuildHook ];

  nativeCheckInputs = [
    protobuf
    pytestCheckHook
  ];

  enabledTestPaths = [ "fdp-scan-pyo3/tests" ];

  pythonImportsCheck = [ "fdp_scan_lib" ];

  meta = {
    description = "Python bindings to the scan for protobuf descriptors embedded in binaries";
    homepage = "https://github.com/douzebis/prototools";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ douzebis ];
  };
}
