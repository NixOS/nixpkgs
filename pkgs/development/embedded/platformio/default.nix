
{ newScope, fetchFromGitHub }:

let
  callPackage = newScope self;

  version = "5.2.4";

  # pypi tarballs don't contain tests - https://github.com/platformio/platformio-core/issues/1964
  src = fetchFromGitHub {
    owner = "platformio";
    repo = "platformio-core";
    rev = "v${version}";
    sha256 = "1dhyxrdxrca669qm6alxxn2jmvcwlpqrx9kfwh4iqy9za5717ag9";
  };

  self = {
    platformio-chrootenv = callPackage ./chrootenv.nix { inherit version src; };
  };

in self
