
{ newScope, fetchFromGitHub }:

let
  callPackage = newScope self;

  version = "5.2.3";

  # pypi tarballs don't contain tests - https://github.com/platformio/platformio-core/issues/1964
  src = fetchFromGitHub {
    owner = "platformio";
    repo = "platformio-core";
    rev = "v${version}";
    sha256 = "0wbmwawn25srkyrd6hwrgli1himzsj08vbm76fgnpqdc84n78ckl";
  };

  self = {
    platformio-chrootenv = callPackage ./chrootenv.nix { inherit version src; };
  };

in self
