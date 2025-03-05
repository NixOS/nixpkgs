{
  callPackage,
  fetchpatch,
  ignition-cmake_2,
  ignition-math_6,
  ignition-msgs_5,
  ignition-utils_1,
}:

(
  (callPackage ./generic.nix {
    gz-cmake = ignition-cmake_2;
    gz-math = ignition-math_6;
    gz-msgs = ignition-msgs_5;
    gz-utils = ignition-utils_1;
  })
  {
    version = "8.4.0";
    hash = "sha256-ca11gJkGzK8AiFQc+0F98968yrnvzS4lHjWYA/JF5g8=";
  }
).overrideAttrs
  (finalAttrs: {
    # Fix compatibility with protobuf 22
    patches = [
      (fetchpatch {
        url = "https://github.com/gazebosim/gz-transport/commit/3d68f46329ec6e4efe20c5125caceae83d4f8e45.patch";
        hash = "sha256-23qSKsMSVL4sXFQrTggyUmxBJm/6RsKsB5EI09GRNKQ=";
      })
    ];
  })
