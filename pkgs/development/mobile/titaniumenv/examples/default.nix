{ nixpkgs ? <nixpkgs>
, systems ? [ "x86_64-linux" "x86_64-darwin" ]
, xcodeVersion ? "6.1.1"
, xcodeBaseDir ? "/Applications/Xcode.app"
, tiVersion ? "3.5.1.GA"
, rename ? false
, newBundleId ? "com.example.kitchensink", iosMobileProvisioningProfile ? null, iosCertificate ? null, iosCertificateName ? "Example", iosCertificatePassword ? "", iosVersion ? "8.1", iosWwdrCertificate ? null
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
    titaniumenv = pkgs.titaniumenv.override { inherit xcodeVersion xcodeBaseDir tiVersion; };
    inherit tiVersion;
    target = "android";
  });
  
  kitchensink_android_release = pkgs.lib.genAttrs systems (system:
  let
    pkgs = import nixpkgs { inherit system; config.allowUnfree = allowUnfree; };
  in
  import ./kitchensink {
    inherit (pkgs) fetchgit;
    titaniumenv = pkgs.titaniumenv.override { inherit xcodeVersion xcodeBaseDir tiVersion; };
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
    titaniumenv = pkgs.titaniumenv.override { inherit xcodeVersion xcodeBaseDir tiVersion; };
    inherit tiVersion iosVersion;
    target = "iphone";
  };

  simulate_kitchensink = import ./simulate-kitchensink {
    inherit (pkgs) stdenv;
    xcodeenv = pkgs.xcodeenv.override { version = xcodeVersion; inherit xcodeBaseDir; };
    kitchensink = kitchensink_ios_development;
    bundleId = if rename then newBundleId else "com.appcelerator.kitchensink";
  };
} else {}) // (if rename then
  let
    pkgs = import nixpkgs { system = "x86_64-darwin"; config.allowUnfree = allowUnfree; };
  in
  {
    kitchensink_ipa = import ./kitchensink {
      inherit (pkgs) stdenv fetchgit;
      titaniumenv = pkgs.titaniumenv.override { inherit xcodeVersion xcodeBaseDir tiVersion; };
      target = "iphone";
      inherit tiVersion;
      release = true;
      rename = true;
      inherit newBundleId iosMobileProvisioningProfile iosCertificate iosCertificateName iosCertificatePassword iosVersion iosWwdrCertificate;
      inherit enableWirelessDistribution installURL;
    };
  }
  
else {})
