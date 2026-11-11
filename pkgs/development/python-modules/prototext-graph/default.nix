{
  lib,
  buildPythonPackage,
  rustPlatform,
  reproto,
}:

buildPythonPackage {
  pname = "prototext-graph";
  inherit (reproto) src version cargoDeps;
  pyproject = true;
  __structuredAttrs = true;

  # nixpkgs-update: no auto update
  # Built from reproto's source, at its version, with its vendored crates:
  # reproto needs all four of these libraries at exactly its version, so
  # they move with it, in reproto's update.

  buildAndTestSubdir = "prototext-graph-pyo3";

  nativeBuildInputs = [ rustPlatform.cargoSetupHook ];

  build-system = [ rustPlatform.maturinBuildHook ];

  # There are no Python tests
  doCheck = false;

  pythonImportsCheck = [ "prototext_graph_lib" ];

  meta = {
    description = "Python bindings to the prototools scoring graph builder";
    homepage = "https://github.com/douzebis/prototools";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ douzebis ];
  };
}
