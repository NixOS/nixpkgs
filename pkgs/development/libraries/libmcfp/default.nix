<<<<<<< HEAD
{ lib
, stdenv
, cmake
, fetchFromGitHub
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libmcfp";
  version = "1.2.4";

  src = fetchFromGitHub {
    owner = "mhekkel";
    repo = "libmcfp";
    rev = "refs/tags/v${finalAttrs.version}";
    hash = "sha256-Xz7M3TmUHGqiYZbFGSDxsVvg4VhgoVvr9TW03UxdFBw=";
  };

  nativeBuildInputs = [
    cmake
  ];
=======
{ lib, stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  pname = "libmcfp";
  version = "1.2.3";

  src = fetchFromGitHub {
    owner = "mhekkel";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-Mi5nj8vR1j3V7fIMBrSyhD57emmlkCb0F08+5s7Usj0=";
  };

  nativeBuildInputs = [ cmake ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "Header only library that can collect configuration options from command line arguments";
    homepage = "https://github.com/mhekkel/libmcfp";
<<<<<<< HEAD
    changelog = "https://github.com/mhekkel/libmcfp/blob/${finalAttrs.src.rev}/changelog";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.bsd2;
    maintainers = with maintainers; [ natsukium ];
    platforms = platforms.unix;
  };
<<<<<<< HEAD
})
=======
}
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
