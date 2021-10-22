
{ newScope, fetchFromGitHub }:

let
  callPackage = newScope self;

  version = "5.2.1";

  # pypi tarballs don't contain tests - https://github.com/platformio/platformio-core/issues/1964
  src = fetchFromGitHub {
    owner = "platformio";
    repo = "platformio-core";
    rev = "v${version}";
    sha256 = "1kmwr21djcz1qnpbsk0za244rp6rkh0vp6wss1vjks4waambiqnl";
  };

  self = {
    platformio-chrootenv = callPackage ./chrootenv.nix { inherit version src; };
  };

in self
