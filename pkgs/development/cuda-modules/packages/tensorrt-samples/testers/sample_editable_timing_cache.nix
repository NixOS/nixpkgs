{
  atLeast,
  lib,
  mkTester,
  ...
}:
lib.optionalAttrs (atLeast "10.8") {
  default = mkTester "sample_editable_timing_cache" [
    "sample_editable_timing_cache"
  ];
}
