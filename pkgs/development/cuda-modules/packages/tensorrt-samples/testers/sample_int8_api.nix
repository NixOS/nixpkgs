{
  backendStdenv,
  lib,
  mkTester,
  older,
  sample-data,
  ...
}:
# sampleINT8API was removed in 11.0, along with implicit quantization.
lib.optionalAttrs (older "11.0") (
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
)
