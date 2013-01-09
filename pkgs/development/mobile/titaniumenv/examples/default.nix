let
  pkgs = import <nixpkgs> {};
  pkgs_i686 = import <nixpkgs> { system = "i686-linux"; };
in
rec {
  titaniumenv = import ./.. {
    inherit pkgs pkgs_i686;
  };
  
  kitchensink_android = import ./kitchensink {
    inherit titaniumenv;
    inherit (pkgs) fetchgit;
    target = "android";
  };
  
  kitchensink_iphone = import ./kitchensink {
    inherit titaniumenv;
    inherit (pkgs) fetchgit;
    target = "iphone";
  };
  
  emulate_kitchensink = import ./emulate-kitchensink {
    inherit (titaniumenv) androidenv;
    kitchensink = kitchensink_android;
  };
  
  simulate_kitchensink_iphone = import ./simulate-kitchensink {
    inherit (titaniumenv) xcodeenv;
    kitchensink = kitchensink_iphone;
    device = "iPhone";
  };
  
  simulate_kitchensink_ipad = import ./simulate-kitchensink {
    inherit (titaniumenv) xcodeenv;
    kitchensink = kitchensink_iphone;
    device = "iPad";
  };
}
