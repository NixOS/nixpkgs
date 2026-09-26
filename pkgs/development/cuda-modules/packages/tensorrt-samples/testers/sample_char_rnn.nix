{
  mkTester,
  sample-data,
  ...
}:
{
  default = mkTester "sample_char_rnn" [
    "sample_char_rnn"
    "--datadir=${sample-data.outPath + "/char-rnn"}"
  ];
}
