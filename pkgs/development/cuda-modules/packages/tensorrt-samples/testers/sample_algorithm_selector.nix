{
  atLeast,
  backendStdenv,
  lib,
  mkTester,
  older,
  sample-data,
  ...
}:
# While available on both 10.8 and 10.9, NVIDIA removed this sample from their CMakeLists.txt, so
# we cannot build it.
lib.optionalAttrs (older "10.8") (
  {
    default = mkTester "sample_algorithm_selector" [
      "sample_algorithm_selector"
      "--datadir=${sample-data.outPath + "/mnist"}"
    ];

    int8 = mkTester "sample_algorithm_selector-int8" [
      "sample_algorithm_selector"
      "--datadir=${sample-data.outPath + "/mnist"}"
      "--int8"
    ];

    fp16 = mkTester "sample_algorithm_selector-fp16" [
      "sample_algorithm_selector"
      "--datadir=${sample-data.outPath + "/mnist"}"
      "--fp16"
    ];
  }
  // lib.optionalAttrs (atLeast "10") {
    bf16 = mkTester "sample_algorithm_selector-bf16" [
      "sample_algorithm_selector"
      "--datadir=${sample-data.outPath + "/mnist"}"
      "--bf16"
    ];
  }
  # Only Xavier and Orin have a DLA
  // lib.optionalAttrs (lib.subtractLists [ "7.2" "8.7" ] backendStdenv.cudaCapabilities == [ ]) {
    dla = mkTester "sample_algorithm_selector-dla" [
      "sample_algorithm_selector"
      "--datadir=${sample-data.outPath + "/mnist"}"
      "--useDLACore=0"
    ];
  }
)
