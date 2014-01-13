{ nixpkgs ? <nixpkgs>
, systems ? [ "x86_64-linux" "x86_64-darwin" ]
, xcodeVersion ? "5.0"
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
      inherit (pkgs) fetchgit;
      titaniumenv = pkgs.titaniumenv.override { inherit xcodeVersion; };
      target = "android";
    });
  
  emulate_kitchensink = pkgs.lib.genAttrs systems (system:
  let
    pkgs = import nixpkgs { inherit system; };
  in
    import ./emulate-kitchensink {
      inherit (pkgs) androidenv;
      kitchensink = builtins.getAttr system kitchensink_android;
    });
  
} // (if builtins.elem "x86_64-darwin" systems then 
  let
    pkgs = import nixpkgs { system = "x86_64-darwin"; };
  in
  rec {
    kitchensink_iphone = import ./kitchensink {
      inherit (pkgs) fetchgit;
      titaniumenv = pkgs.titaniumenv.override { inherit xcodeVersion; };
      target = "iphone";
    };

    simulate_kitchensink_iphone = import ./simulate-kitchensink {
      inherit (pkgs) stdenv;
      xcodeenv = pkgs.xcodeenv.override { version = xcodeVersion; };
      kitchensink = kitchensink_iphone;
      device = "iPhone";
    };
  
    simulate_kitchensink_ipad = import ./simulate-kitchensink {
      inherit (pkgs) stdenv;
      xcodeenv = pkgs.xcodeenv.override { version = xcodeVersion; };
      kitchensink = kitchensink_iphone;
      device = "iPad";
    };
} else {})
