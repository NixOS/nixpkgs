import ./generic.nix {
  version = "0.11.1";
  urls = [
    "https://src.fedoraproject.org/repo/pkgs/gcc/isl-0.11.1.tar.bz2/bce1586384d8635a76d2f017fb067cd2/isl-0.11.1.tar.bz2"
  ];
  sha256 = "13d9cqa5rzhbjq0xf0b2dyxag7pqa72xj9dhsa03m8ccr1a4npq9";
  patches = [ ./fix-gcc-build.diff ];
}
