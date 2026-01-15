{
  backendStdenv,
  lib,
  mkTester,
  sample-data,
  ...
}:
{
  default = mkTester "sample_onnx_mnist" [
    "sample_onnx_mnist"
    "--datadir=${sample-data.outPath + "/mnist"}"
  ];

  int8 = mkTester "sample_onnx_mnist-int8" [
    "sample_onnx_mnist"
    "--datadir=${sample-data.outPath + "/mnist"}"
    "--int8"
  ];

  fp16 = mkTester "sample_onnx_mnist-fp16" [
    "sample_onnx_mnist"
    "--datadir=${sample-data.outPath + "/mnist"}"
    "--fp16"
  ];

  bf16 = mkTester "sample_onnx_mnist-bf16" [
    "sample_onnx_mnist"
    "--datadir=${sample-data.outPath + "/mnist"}"
    "--bf16"
  ];
}
# Only Orin has a DLA
// lib.optionalAttrs (lib.elem "8.7" backendStdenv.cudaCapabilities) {
  dla = mkTester "sample_onnx_mnist-dla" [
    "sample_onnx_mnist"
    "--datadir=${sample-data.outPath + "/mnist"}"
    "--useDLACore=0"
  ];
}
