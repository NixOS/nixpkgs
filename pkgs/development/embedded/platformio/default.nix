
{ stdenv, lib, newScope, fetchFromGitHub }:

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

  meta = with lib; {
    broken = stdenv.isAarch64;
    description = "An open source ecosystem for IoT development";
    homepage = "https://platformio.org";
    license = licenses.asl20;
    maintainers = with maintainers; [ mog makefu oxzi ];
  };

  self = {
    platformio-chrootenv = callPackage ./chrootenv.nix { inherit version src meta; };
  };

in self
