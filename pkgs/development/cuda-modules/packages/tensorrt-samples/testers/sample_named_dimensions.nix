{
  finalAttrs,
  mkTester,
  older,
  python3,
  runCommand,
  ...
}:
let
  # From 11.0, the sample no longer ships concat_layer.onnx; it provides create_model.py (which uses
  # onnx-graphsurgeon) to generate it instead. We build the equivalent model with the ONNX helper API.
  datadir =
    if older "11.0" then
      finalAttrs.src.outPath + "/samples/sampleNamedDimensions"
    else
      runCommand "${finalAttrs.name}-sample_named_dimensions-data"
        {
          __structuredAttrs = true;
          strictDeps = true;
          nativeBuildInputs = [ (python3.withPackages (ps: [ ps.onnx ])) ];
        }
        ''
          mkdir -p "$out"
          cd "$out"
          python3 - <<'EOF'
          import onnx
          from onnx import TensorProto, helper

          input0 = helper.make_tensor_value_info("input0", TensorProto.FLOAT, ["n_rows", 8])
          input1 = helper.make_tensor_value_info("input1", TensorProto.FLOAT, ["n_rows", 8])
          output = helper.make_tensor_value_info("output", TensorProto.FLOAT, None)
          node = helper.make_node("Concat", ["input0", "input1"], ["output"], axis=0)
          graph = helper.make_graph([node], "concat_layer", [input0, input1], [output])
          onnx.save(helper.make_model(graph), "concat_layer.onnx")
          EOF
        '';
in
{
  default = mkTester "sample_named_dimensions" [
    "sample_named_dimensions"
    "--datadir=${datadir}"
  ];
}
