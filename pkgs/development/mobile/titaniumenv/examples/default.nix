{ nixpkgs ? <nixpkgs>
, systems ? [ "x86_64-linux" "x86_64-darwin" ]
, xcodeVersion ? "5.0"
, tiVersion ? "3.2.3.GA"
, rename ? false
, newBundleId ? "com.example.kitchensink", iosMobileProvisioningProfile ? null, iosCertificate ? null, iosCertificateName ? "Example", iosCertificatePassword ? ""
, allowUnfree ? false
, enableWirelessDistribution ? false, installURL ? null
}:

let
  pkgs = import nixpkgs { config.allowUnfree = allowUnfree; };
in
rec {
  kitchensink_android_debug = pkgs.lib.genAttrs systems (system:
  let
    pkgs = import nixpkgs { inherit system; config.allowUnfree = allowUnfree; };
  in
  import ./kitchensink {
    inherit (pkgs) fetchgit;
    titaniumenv = pkgs.titaniumenv.override { inherit xcodeVersion tiVersion; };
    inherit tiVersion;
    target = "android";
  });
  
  kitchensink_android_release = pkgs.lib.genAttrs systems (system:
  let
    pkgs = import nixpkgs { inherit system; config.allowUnfree = allowUnfree; };
  in
  import ./kitchensink {
    inherit (pkgs) fetchgit;
    titaniumenv = pkgs.titaniumenv.override { inherit xcodeVersion tiVersion; };
    inherit tiVersion;
    target = "android";
    release = true;
  });
  
  emulate_kitchensink_debug = pkgs.lib.genAttrs systems (system:
  let
    pkgs = import nixpkgs { inherit system; config.allowUnfree = allowUnfree; };
  in
  import ./emulate-kitchensink {
    inherit (pkgs) androidenv;
    kitchensink = builtins.getAttr system kitchensink_android_debug;
  });
  
  emulate_kitchensink_release = pkgs.lib.genAttrs systems (system:
  let
    pkgs = import nixpkgs { inherit system; config.allowUnfree = allowUnfree; };
  in
  import ./emulate-kitchensink {
    inherit (pkgs) androidenv;
    kitchensink = builtins.getAttr system kitchensink_android_release;
  });
  
} // (if builtins.elem "x86_64-darwin" systems then 
  let
    pkgs = import nixpkgs { system = "x86_64-darwin"; };
  in
  rec {
  kitchensink_ios_development = import ./kitchensink {
    inherit (pkgs) fetchgit;
    titaniumenv = pkgs.titaniumenv.override { inherit xcodeVersion tiVersion; };
    inherit tiVersion;
    target = "iphone";
  };

  simulate_kitchensink_iphone = import ./simulate-kitchensink {
    inherit (pkgs) stdenv;
    xcodeenv = pkgs.xcodeenv.override { version = xcodeVersion; };
    kitchensink = kitchensink_ios_development;
    device = "iPhone";
  };
  
  simulate_kitchensink_ipad = import ./simulate-kitchensink {
    inherit (pkgs) stdenv;
    xcodeenv = pkgs.xcodeenv.override { version = xcodeVersion; };
    kitchensink = kitchensink_ios_development;
    device = "iPad";
  };
} else {}) // (if rename then
  let
    pkgs = import nixpkgs { system = "x86_64-darwin"; config.allowUnfree = allowUnfree; };
  in
  {
    kitchensink_ipa = import ./kitchensink {
      inherit (pkgs) stdenv fetchgit;
      titaniumenv = pkgs.titaniumenv.override { inherit xcodeVersion tiVersion; };
      target = "iphone";
      inherit tiVersion;
      release = true;
      rename = true;
      inherit newBundleId iosMobileProvisioningProfile iosCertificate iosCertificateName iosCertificatePassword;
      inherit enableWirelessDistribution installURL;
    };
  }
  
else {})
