{ nixpkgs ? <nixpkgs>
, systems ? [ "x86_64-linux" "x86_64-darwin" ]
}:

let
  pkgs = import nixpkgs {};
in
rec {
  kitchensink_android = pkgs.lib.genAttrs systems (system:
  let
    pkgs = import nixpkgs { inherit system; };
  in
    import ./kitchensink {
      inherit (pkgs) fetchgit titaniumenv;
      target = "android";
    });
  
  emulate_kitchensink = pkgs.lib.genAttrs systems (system:
  let
    pkgs = import nixpkgs { inherit system; };
  in
    import ./emulate-kitchensink {
      inherit (pkgs.titaniumenv) androidenv;
      kitchensink = kitchensink_android;
    });
  
} // (if builtins.elem "x86_64-darwin" systems then 
  let
    pkgs = import nixpkgs { system = "x86_64-darwin"; };
  in
  rec {
    kitchensink_iphone = import ./kitchensink {
      inherit (pkgs) fetchgit titaniumenv;
      target = "iphone";
    };

    simulate_kitchensink_iphone = import ./simulate-kitchensink {
      inherit (pkgs) stdenv;
      inherit (pkgs.titaniumenv) xcodeenv;
      kitchensink = kitchensink_iphone;
      device = "iPhone";
    };
  
    simulate_kitchensink_ipad = import ./simulate-kitchensink {
      inherit (pkgs) stdenv;
      inherit (pkgs.titaniumenv) xcodeenv;
      kitchensink = kitchensink_iphone;
      device = "iPad";
    };
} else {})
