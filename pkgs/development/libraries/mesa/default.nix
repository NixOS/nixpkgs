{ stdenv
, callPackage
, substituteAll
, fetchgit
, systemd
, bison
, flex
, llvmPackages-svn
, grsecEnabled ? false
, enableTextureFloats ? false # Texture floats are patented, see docs/patents.txt
, ...
} @ args :

with stdenv.lib;

let
  common = attr: callPackage ./generic.nix (args // attr);

in {

  mesa_13_0_2 = common {
    version = "13.0.2";
    sha256 = "a6ed622645f4ed61da418bf65adde5bcc4bb79023c36ba7d6b45b389da4416d5";
  };

  mesa_13_1_0-git = common {
    version = "13.1.0-dev";
    src = fetchgit {
      url = "git://anongit.freedesktop.org/mesa/mesa";
      rev = "9fe3f2649ea20d3ab736475faec6209fc3ff7c66";
      sha256 = "0i9nlpv694rs7cw1k6qg1plvangjbhqnmbysy7ba8pm5a9x65c4g";
    };
    extraPatches = [
      ./vulkan-icd-paths.patch
    ];
    llvmPackages = llvmPackages-svn;
    buildInputs = [ bison flex ];
  };

}
