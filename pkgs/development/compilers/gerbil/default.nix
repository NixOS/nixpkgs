{ callPackage, fetchFromGitHub }:

callPackage ./build.nix rec {
<<<<<<< HEAD
  version = "0.17";
=======
  version = "0.16";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  git-version = version;
  src = fetchFromGitHub {
    owner = "vyzo";
    repo = "gerbil";
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "0xzi9mhrmzcajhlz5qcnz4yjlljvbkbm9426iifgjn47ac0965zw";
=======
    sha256 = "0vng0kxpnwsg8jbjdpyn4sdww36jz7zfpfbzayg9sdpz6bjxjy0f";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
