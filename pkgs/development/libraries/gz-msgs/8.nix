{
  callPackage,
  fetchpatch,
  ignition-cmake_2,
  ignition-math_6,
}:

(
  (callPackage ./generic.nix {
    gz-cmake = ignition-cmake_2;
    gz-math = ignition-math_6;
    gz-utils = null;
  })
  {
    version = "8.7.0";
    hash = "sha256-hG4UJfcq6DsyMqTWIcUQ15UCQNfdzTzwvJBpR9kmu84=";
  }
).overrideAttrs
  (finalAttrs: {
    # Don't require Protobuf 3
    patches = [
      (fetchpatch {
        url = "https://github.com/gazebosim/gz-msgs/commit/0c0926c37042ac8f5aeb49ac36101acd3e084c6b.patch";
        hash = "sha256-QnR1WtB4gbgyJKbQ4doMhfSjJBksEeQ3Us4y9KqCWeY=";
      })
    ];
  })
