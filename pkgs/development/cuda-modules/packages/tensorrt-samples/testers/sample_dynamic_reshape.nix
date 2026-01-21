{
  atLeast,
  lib,
  mkTester,
  sample-data,
  ...
}:
{
  default = mkTester "sample_dynamic_reshape" [
    "sample_dynamic_reshape"
    "--datadir=${sample-data.outPath + "/mnist"}"
  ];

  # TODO(@connorbaker): Neither the sample data nor the sample sources provide train-images-idx3-ubyte, so we can't run the int8 test.
  # int8 = mkTester "sample_dynamic_reshape-int8" [
  #   "sample_dynamic_reshape"
  #   "--datadir=${sample-data.outPath + "/mnist"}"
  #   "--int8"
  # ];

  fp16 = mkTester "sample_dynamic_reshape-fp16" [
    "sample_dynamic_reshape"
    "--datadir=${sample-data.outPath + "/mnist"}"
    "--fp16"
  ];
}
// lib.optionalAttrs (atLeast "10") {
  bf16 = mkTester "sample_dynamic_reshape-bf16" [
    "sample_dynamic_reshape"
    "--datadir=${sample-data.outPath + "/mnist"}"
    "--bf16"
  ];
}
