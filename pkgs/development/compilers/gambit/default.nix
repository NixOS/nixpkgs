{ callPackage, fetchurl }:

callPackage ./build.nix rec {
<<<<<<< HEAD
  version = "4.9.5";
  git-version = version;
  src = fetchurl {
    url = "https://gambitscheme.org/4.9.5/gambit-v4_9_5.tgz";
    sha256 = "sha256-4o74218OexFZcgwVAFPcq498TK4fDlyDiUR5cHP4wdw=";
=======
  version = "4.9.3";
  git-version = version;
  src = fetchurl {
    url = "http://www.iro.umontreal.ca/~gambit/download/gambit/v4.9/source/gambit-v4_9_3.tgz";
    sha256 = "1p6172vhcrlpjgia6hsks1w4fl8rdyjf9xjh14wxfkv7dnx8a5hk";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
