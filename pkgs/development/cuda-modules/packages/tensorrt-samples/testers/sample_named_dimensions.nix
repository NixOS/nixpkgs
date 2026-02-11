{
  finalAttrs,
  mkTester,
  ...
}:
{
  default = mkTester "sample_named_dimensions" [
    "sample_named_dimensions"
    "--datadir=${finalAttrs.src.outPath + "/samples/sampleNamedDimensions"}"
  ];
}
