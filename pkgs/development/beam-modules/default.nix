{ stdenv, pkgs, erlang, overrides ? (self: super: {}) }:

let
  inherit (stdenv.lib) fix' extends getVersion versionAtLeast;

  lib = pkgs.callPackage ./lib.nix {};

  # FIXME: add support for overrideScope
  callPackageWithScope = scope: drv: args: stdenv.lib.callPackageWith scope drv args;
  mkScope = scope: pkgs // scope;

  packages = self:
    let
      defaultScope = mkScope self;
      callPackage = drv: args: callPackageWithScope defaultScope drv args;
    in
      import ./hex-packages.nix {
        inherit pkgs stdenv callPackage;
      } // {
        inherit callPackage erlang;
        beamPackages = self;

        rebar = callPackage ../tools/build-managers/rebar { };
        rebar3-open = callPackage ../tools/build-managers/rebar3 {
          hermeticRebar3 = false;
        };
        rebar3 = callPackage ../tools/build-managers/rebar3 {
          hermeticRebar3 = true;
        };

        hexRegistrySnapshot = callPackage ./hex-registry-snapshot.nix { };
        fetchHex = callPackage ./fetch-hex.nix { };

        buildRebar3 = callPackage ./build-rebar3.nix {};
        buildHex = callPackage ./build-hex.nix {};
        buildErlangMk = callPackage ./build-erlang-mk.nix {};
        buildMix = callPackage ./build-mix.nix {};

        # BEAM-based languages.
        elixir = if versionAtLeast (lib.getVersion erlang) "18"
                 then callPackage ../interpreters/elixir { debugInfo = true; }
                 else throw "Elixir requires at least Erlang/OTP R18.";
        lfe = callPackage ../interpreters/lfe { };

        # Non hex packages
        hex = callPackage ./hex {};
        webdriver = callPackage ./webdriver {};

        hex2nix = callPackage ../tools/erlang/hex2nix {};
        cuter = callPackage ../tools/erlang/cuter {};
        relxExe = callPackage ../tools/erlang/relx-exe {};
      };
in fix' (extends overrides packages)
