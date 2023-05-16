{ callPackage, fetchurl }:

callPackage ./generic.nix rec {
<<<<<<< HEAD
  version = "3.9.1";

  src = fetchurl {
    url = "mirror://gnu/nettle/nettle-${version}.tar.gz";
    hash = "sha256-zP7/mBsMpxu9b7ywVPQHxg/7ZEOJpb6A1nFtW1UMbOM=";
=======
  version = "3.8.1";

  src = fetchurl {
    url = "mirror://gnu/nettle/nettle-${version}.tar.gz";
    hash = "sha256-Nk8+K3fNfc3oP9fEUhnINOVLDHXkKLb4lKI9Et1By/4=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
