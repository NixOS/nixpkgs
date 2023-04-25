{ fetchpatch
, callPackage
}:

callPackage ./generic.nix {
  version = "3.1.0";
  hash = "sha256-gIpyuNlp3mvR8r1Azs2r76ElEodykRLGAwMN4BDJez0=";
  patches = [
    # Search for GoogleTest via pkg-config first, ref: https://github.com/NixOS/nixpkgs/pull/130525
    (fetchpatch {
      url = "https://github.com/microsoft/GSL/commit/f5cf01083baf7e8dc8318db3648bc6098dc32d67.patch";
      sha256 = "sha256-HJxG87nVFo1CGNivCqt/JhjTj2xLzQe8bF5Km7/KG+Y=";
    })
  ];
}
