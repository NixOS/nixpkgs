{
  cudaConfig,
  lib,
  mkTester,
  sample-data,
  ...
}:
{
  default = mkTester "sample_io_formats" [
    "sample_io_formats"
    "--datadir=${sample-data.outPath + "/mnist"}"
  ];
}
# Only Xavier and Orin have a DLA
// lib.optionalAttrs (lib.subtractLists [ "7.2" "8.7" ] cudaConfig.cudaCapabilities == [ ]) {
  dla = mkTester "sample_io_formats-dla" [
    "sample_io_formats"
    "--datadir=${sample-data.outPath + "/mnist"}"
    "--useDLACore=0"
  ];
}
