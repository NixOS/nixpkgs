{ newScope, fetchFromGitHub }:

let
  callPackage = newScope self;

  version = "6.1.6";

  # pypi tarballs don't contain tests - https://github.com/platformio/platformio-core/issues/1964
  src = fetchFromGitHub {
    owner = "platformio";
    repo = "platformio-core";
    rev = "v${version}";
    sha256 = "sha256-BEeMfdmAWqFbQUu8YKKrookQVgmhfZBqXnzeb2gfhms=";
  };

  self = {
    platformio-chrootenv = callPackage ./chrootenv.nix { inherit version src; };
  };

in
self
