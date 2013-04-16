{ nixpkgs ? <nixpkgs>
, system ? builtins.currentSystem
, version ? "3.1"
}:

let
  pkgs = import nixpkgs { inherit system; };
  pkgs_darwin_x86_64 = import nixpkgs { system = "x86_64-darwin"; };
  versionString = pkgs.stdenv.lib.replaceChars [ "." ] [ "_" ] version;
in
rec {
  kitchensink_android = import ./kitchensink {
    inherit (pkgs) fetchgit;
    titaniumenv = builtins.getAttr "titaniumenv_${versionString}" pkgs;
    target = "android";
  };
  
  kitchensink_iphone = import ./kitchensink {
    inherit (pkgs_darwin_x86_64) fetchgit;
    titaniumenv = builtins.getAttr "titaniumenv_${versionString}" pkgs_darwin_x86_64;
    target = "iphone";
  };
  
  emulate_kitchensink = import ./emulate-kitchensink {
    inherit (pkgs.titaniumenv) androidenv;
    kitchensink = kitchensink_android;
  };
  
  simulate_kitchensink_iphone = import ./simulate-kitchensink {
    inherit (pkgs_darwin_x86_64.titaniumenv) xcodeenv;
    kitchensink = kitchensink_iphone;
    device = "iPhone";
  };
  
  simulate_kitchensink_ipad = import ./simulate-kitchensink {
    inherit (pkgs_darwin_x86_64.titaniumenv) xcodeenv;
    kitchensink = kitchensink_iphone;
    device = "iPad";
  };
}
