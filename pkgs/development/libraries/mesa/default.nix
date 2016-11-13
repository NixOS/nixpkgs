{ stdenv
, callPackage
, substituteAll
, systemd
, grsecEnabled ? false
, enableTextureFloats ? false # Texture floats are patented, see docs/patents.txt
, ...
} @ args :

with stdenv.lib;

let
  common = attr: callPackage ./generic.nix (args // attr);

in {

  mesa_13_0_2 = common {
    version = "13.0.0";
    sha256 = "a6ed622645f4ed61da418bf65adde5bcc4bb79023c36ba7d6b45b389da4416d5";
    enableRadv = true;
    extraPatches = [
      ./vulkan-icd-paths.patch
    ];
  };

}
