{
  backendStdenv,
  lib,
  mkTester,
  sample-data,
  ...
}:
# NOTE: Disabled because it generates way too much output.
lib.optionalAttrs false (
  {
    default = mkTester "sample_progress_monitor" [
      "sample_progress_monitor"
      "--datadir=${sample-data.outPath + "/mnist"}"
    ];

    int8 = mkTester "sample_progress_monitor-int8" [
      "sample_progress_monitor"
      "--datadir=${sample-data.outPath + "/mnist"}"
      "--int8"
    ];

    fp16 = mkTester "sample_progress_monitor-fp16" [
      "sample_progress_monitor"
      "--datadir=${sample-data.outPath + "/mnist"}"
      "--fp16"
    ];
  }
  # Only Xavier and Orin have a DLA
  // lib.optionalAttrs (lib.subtractLists [ "7.2" "8.7" ] backendStdenv.cudaCapabilities == [ ]) {
    dla = mkTester "sample_progress_monitor-dla" [
      "sample_progress_monitor"
      "--datadir=${sample-data.outPath + "/mnist"}"
      "--useDLACore=0"
    ];
  }
)
