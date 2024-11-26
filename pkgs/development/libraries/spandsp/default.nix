{ fetchurl
, callPackage
}:

(callPackage ./common.nix {}).overrideAttrs(_: rec {
  version = "0.0.6";
  src = fetchurl {
    url = "https://www.soft-switch.org/downloads/spandsp/spandsp-${version}.tar.gz";
    sha256 = "0rclrkyspzk575v8fslzjpgp4y2s4x7xk3r55ycvpi4agv33l1fc";
  };
})
