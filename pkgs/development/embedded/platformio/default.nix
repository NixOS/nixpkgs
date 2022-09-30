{ newScope, fetchFromGitHub }:

let
  callPackage = newScope self;

  version = "6.1.4";

  # pypi tarballs don't contain tests - https://github.com/platformio/platformio-core/issues/1964
  src = fetchFromGitHub {
    owner = "platformio";
    repo = "platformio-core";
    rev = "v${version}";
    sha256 = "sha256-PLVsXnaflEZdn12lWrpnm8+uNfwB+T7JXnvjQihfuSs=";
  };

  self = {
    platformio-chrootenv = callPackage ./chrootenv.nix { inherit version src; };
  };

in
self
