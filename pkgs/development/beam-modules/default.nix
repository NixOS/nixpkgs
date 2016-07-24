{ pkgs, stdenv, erlang
, interpreterConfig ? (self: super: {})
, overrides ? (self: super: {})
}:

let
  inherit (stdenv.lib) fix' extends optionalAttrs;

  beamPackages = self:
    let
      callPackageWithScope = scope: drv: args: (stdenv.lib.callPackageWith scope drv args) // {
        overrideScope = f: callPackageWithScope (mkScope (fix' (extends f scope.__unfix__))) drv args;
      };

      mkScope = scope: pkgs // scope;
      defaultScope = mkScope self;
      callPackage = drv: args: callPackageWithScope defaultScope drv args;

    in import ./hex-packages.nix { inherit pkgs stdenv callPackage; } self // {
      inherit callPackage erlang;

      rebar = callPackage ../../development/tools/build-managers/rebar {};
      rebar3 = callPackage ../../development/tools/build-managers/rebar3 {};

      buildRebar3 = callPackage ./build-rebar3.nix {};
      buildHex = callPackage ./build-hex.nix {};
      buildErlangMk = callPackage ./build-erlang-mk.nix {};
      buildMix = callPackage ./build-mix.nix {};

      hex = callPackage ./hex {};
      webdriver = callPackage ./webdriver {};
    };

in fix'
  (extends overrides
    (extends interpreterConfig beamPackages))
