{ stdenv, lib, fetchurl, fetchpatch, fixDarwinDylibNames, nativeBuildRoot }:

import ./base.nix {
  version = "63.1";
  sha256 = "17fbk0lm2clsxbmjzvyp245ayx0n4chji3ky1f3fbz2ljjv91i05";
  patches = [
    # https://bugzilla.mozilla.org/show_bug.cgi?id=1499398
    (fetchpatch {
      url = https://github.com/unicode-org/icu/commit/8baff8f03e07d8e02304d0c888d0bb21ad2eeb01.patch;
      sha256 = "1awfa98ljcf95a85cssahw6bvdnpbq5brf1kgspy14w4mlmhd0jb";
    })
  ];
  patchFlags = [ "-p3" ];
} { inherit stdenv lib fetchurl fixDarwinDylibNames nativeBuildRoot; }
