
{ newScope, fetchFromGitHub }:

let
  callPackage = newScope self;

  version = "5.1.1";

  # pypi tarballs don't contain tests - https://github.com/platformio/platformio-core/issues/1964
  src = fetchFromGitHub {
    owner = "platformio";
    repo = "platformio-core";
    rev = "v${version}";
    sha256 = "1m9vq5r4g04n3ckmb3hrrc4ar5v31k6isc76bw4glrn2xb7r8c00";
  };

  self = {
    platformio-chrootenv = callPackage ./chrootenv.nix { inherit version src; };
  };

in self
