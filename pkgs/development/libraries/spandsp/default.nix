{
  fetchurl,
  fetchpatch,
  callPackage,
}:

(callPackage ./common.nix { }) rec {
  version = "0.0.6";
  src = fetchurl {
    url = "https://www.soft-switch.org/downloads/spandsp/spandsp-${version}.tar.gz";
    sha256 = "0rclrkyspzk575v8fslzjpgp4y2s4x7xk3r55ycvpi4agv33l1fc";
  };
  patches = [
    (fetchpatch {
      url = "https://github.com/freeswitch/spandsp/commit/f7b96b08db148763039cf3459d0e00da9636eb92.patch";
      includes = [
        "spandsp-sim/g1050.c"
        "spandsp-sim/test_utils.c"
      ];
      hash = "sha256-2MmVgyMUK0Zn+mL7IX57Y7brYpgmt4GVlis5/NstuNM=";
    })
    (fetchpatch {
      url = "https://github.com/freeswitch/spandsp/commit/f47bcdc301fbddad44e918939eed1b361882f740.patch";
      hash = "sha256-O+lIC3V92GVFoiHsUQOXkoTN2hJ7v5+LQP7RrAhvwlY=";
    })
  ];
}
