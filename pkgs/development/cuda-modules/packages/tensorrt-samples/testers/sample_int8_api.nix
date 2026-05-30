{
  backendStdenv,
  lib,
  mkTester,
  sample-data,
  ...
}:
{
  default = mkTester "sample_int8_api" [
    "sample_int8_api"
    "--model=${sample-data.outPath + "/resnet50/ResNet50.onnx"}"
    "--data=${sample-data.outPath + "/int8_api"}"
  ];
}
# Only Xavier and Orin have a DLA
// lib.optionalAttrs (lib.subtractLists [ "7.2" "8.7" ] backendStdenv.cudaCapabilities == [ ]) {
  dla = mkTester "sample_int8_api-dla" [
    "sample_int8_api"
    "--model=${sample-data.outPath + "/resnet50/ResNet50.onnx"}"
    "--data=${sample-data.outPath + "/int8_api"}"
    "--useDLACore=0"
  ];
}
