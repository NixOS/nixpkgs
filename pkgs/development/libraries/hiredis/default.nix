{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "hiredis";
<<<<<<< HEAD
  version = "1.2.0";
=======
  version = "1.1.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "redis";
    repo = "hiredis";
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-ZxUITm3OcbERcvaNqGQU46bEfV+jN6safPalG0TVfBg=";
=======
    sha256 = "sha256-0ESRnZTL6/vMpek+2sb0YQU3ajXtzj14yvjfOSQYjf4=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  PREFIX = "\${out}";

  meta = with lib; {
    homepage = "https://github.com/redis/hiredis";
    description = "Minimalistic C client for Redis >= 1.2";
    license = licenses.bsd3;
    platforms = platforms.all;
  };
}
