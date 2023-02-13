{ callPackage }:
callPackage ./binary.nix {
  version = "1.16";
  hashes = {
    # Use `print-hashes.sh ${version}` to generate the list below
    darwin-amd64 = "6000a9522975d116bf76044967d7e69e04e982e9625330d9a539a8b45395f9a8";
    darwin-arm64 = "4dac57c00168d30bbd02d95131d5de9ca88e04f2c5a29a404576f30ae9b54810";
    linux-386 = "ea435a1ac6d497b03e367fdfb74b33e961d813883468080f6e239b3b03bea6aa";
    linux-amd64 = "013a489ebb3e24ef3d915abe5b94c3286c070dfe0818d5bca8108f1d6e8440d2";
    linux-arm64 = "3770f7eb22d05e25fbee8fb53c2a4e897da043eb83c69b9a14f8d98562cd8098";
    linux-armv6l = "d1d9404b1dbd77afa2bdc70934e10fbfcf7d785c372efc29462bb7d83d0a32fd";
    linux-ppc64le = "27a1aaa988e930b7932ce459c8a63ad5b3333b3a06b016d87ff289f2a11aacd6";
    linux-s390x = "be4c9e4e2cf058efc4e3eb013a760cb989ddc4362f111950c990d1c63b27ccbe";
  };
}
