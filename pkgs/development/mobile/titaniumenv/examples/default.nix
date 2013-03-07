{ nixpkgs ? <nixpkgs> }:

let
  pkgs = import nixpkgs {};
  pkgs_darwin_x86_64 = import nixpkgs { system = "x86_64-darwin"; };
in
rec {
  kitchensink_android = import ./kitchensink {
    inherit (pkgs) fetchgit titaniumenv;
    target = "android";
  };
  
  kitchensink_iphone = import ./kitchensink {
    inherit (pkgs_darwin_x86_64) fetchgit titaniumenv;
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
