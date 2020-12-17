
{ newScope, fetchFromGitHub }:

let
  callPackage = newScope self;

  version = "5.0.3";

  # pypi tarballs don't contain tests - https://github.com/platformio/platformio-core/issues/1964
  src = fetchFromGitHub {
    owner = "platformio";
    repo = "platformio-core";
    rev = "v${version}";
    sha256 = "0sf5dy0cmhy66rmk0hq1by7nrmf7qz0a99hrk55dpbp6r6vnk3hw";
  };

  self = {
    platformio-chrootenv = callPackage ./chrootenv.nix { inherit version src; };
  };

in self
