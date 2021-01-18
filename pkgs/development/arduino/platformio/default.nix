
{ newScope, fetchFromGitHub }:

let
  callPackage = newScope self;

  version = "5.0.4";

  # pypi tarballs don't contain tests - https://github.com/platformio/platformio-core/issues/1964
  src = fetchFromGitHub {
    owner = "platformio";
    repo = "platformio-core";
    rev = "v${version}";
    sha256 = "15jnhlhkk9z6cyzxw065r3080dqan951klwf65p152vfzg79wf84";
  };

  self = {
    platformio-chrootenv = callPackage ./chrootenv.nix { inherit version src; };
  };

in self
