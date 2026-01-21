{
  backendStdenv,
  lib,
  mkTester,
  sample-data,
  ...
}:
# TODO(@connorbaker): Neither the sample data nor the sample sources provide mnist_with_coordconv.onnx, so we can't run these tests.
lib.optionalAttrs false (
  {
    default = mkTester "sample_onnx_mnist_coord_conv_ac" [
      "sample_onnx_mnist_coord_conv_ac"
      "--datadir=${sample-data.outPath + "/mnist"}"
    ];

    int8 = mkTester "sample_onnx_mnist_coord_conv_ac-int8" [
      "sample_onnx_mnist_coord_conv_ac"
      "--datadir=${sample-data.outPath + "/mnist"}"
      "--int8"
    ];

    fp16 = mkTester "sample_onnx_mnist_coord_conv_ac-fp16" [
      "sample_onnx_mnist_coord_conv_ac"
      "--datadir=${sample-data.outPath + "/mnist"}"
      "--fp16"
    ];
  }
  # Only Xavier and Orin have a DLA
  // lib.optionalAttrs (lib.subtractLists [ "7.2" "8.7" ] backendStdenv.cudaCapabilities == [ ]) {
    dla = mkTester "sample_onnx_mnist_coord_conv_ac-dla" [
      "sample_onnx_mnist_coord_conv_ac"
      "--datadir=${sample-data.outPath + "/mnist"}"
      "--useDLACore=0"
    ];
  }
)
