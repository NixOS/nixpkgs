{
  lib,
  mkTester,
  older,
  sample-data,
  ...
}:
# sampleCharRNN was removed in 11.0.
lib.optionalAttrs (older "11.0") {
  default = mkTester "sample_char_rnn" [
    "sample_char_rnn"
    "--datadir=${sample-data.outPath + "/char-rnn"}"
  ];
}
