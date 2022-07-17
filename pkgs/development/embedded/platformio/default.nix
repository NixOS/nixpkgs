
{ newScope, fetchFromGitHub }:

let
  callPackage = newScope self;

  version = "6.0.2";

  # pypi tarballs don't contain tests - https://github.com/platformio/platformio-core/issues/1964
  src = fetchFromGitHub {
    owner = "platformio";
    repo = "platformio-core";
    rev = "v${version}";
    sha256 = "sha256-yfUF9+M45ZSjmB275kTs8+/Q8Q5FMmr63e3Om8dPi2k=";
  };

  self = {
    platformio-chrootenv = callPackage ./chrootenv.nix { inherit version src; };
  };

in self
