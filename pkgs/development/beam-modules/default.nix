{ lib, pkgs, erlang }:

let
  inherit (lib) makeExtensible;

  lib' = pkgs.callPackage ./lib.nix { };

  # FIXME: add support for overrideScope
  callPackageWithScope = scope: drv: args: lib.callPackageWith scope drv args;
  mkScope = scope: pkgs // scope;

  packages = self:
    let
      defaultScope = mkScope self;
      callPackage = drv: args: callPackageWithScope defaultScope drv args;
    in
    rec {
      inherit callPackage erlang;
      beamPackages = self;

      inherit (callPackage ../tools/build-managers/rebar3 { }) rebar3 rebar3WithPlugins;
      rebar = callPackage ../tools/build-managers/rebar { };

      # rebar3 port compiler plugin is required by buildRebar3
      pc = callPackage ./pc { };
      rebar3-nix = callPackage ./rebar3-nix { };

      fetchHex = callPackage ./fetch-hex.nix { };

      fetchRebar3Deps = callPackage ./fetch-rebar-deps.nix { };
      rebar3Relx = callPackage ./rebar3-release.nix { };

      buildRebar3 = callPackage ./build-rebar3.nix { };
      buildHex = callPackage ./build-hex.nix { };
      buildErlangMk = callPackage ./build-erlang-mk.nix { };
      buildMix = callPackage ./build-mix.nix { };
      fetchMixDeps = callPackage ./fetch-mix-deps.nix { };
      mixRelease = callPackage ./mix-release.nix { };

      erlang-ls = callPackage ./erlang-ls { };

      # BEAM-based languages.
      elixir = elixir_1_11;

      elixir_1_11 = lib'.callElixir ../interpreters/elixir/1.11.nix {
        inherit erlang;
        debugInfo = true;
      };

      elixir_1_10 = lib'.callElixir ../interpreters/elixir/1.10.nix {
        inherit erlang;
        debugInfo = true;
      };

      elixir_1_9 = lib'.callElixir ../interpreters/elixir/1.9.nix {
        inherit erlang;
        debugInfo = true;
      };

      elixir_1_8 = lib'.callElixir ../interpreters/elixir/1.8.nix {
        inherit erlang;
        debugInfo = true;
      };

      elixir_1_7 = lib'.callElixir ../interpreters/elixir/1.7.nix {
        inherit erlang;
        debugInfo = true;
      };

      elixir_ls = callPackage ./elixir_ls.nix { inherit elixir fetchMixDeps mixRelease; };

      # Remove old versions of elixir, when the supports fades out:
      # https://hexdocs.pm/elixir/compatibility-and-deprecations.html

      lfe = lfe_1_3;
      lfe_1_3 = lib'.callLFE ../interpreters/lfe/1.3.nix { inherit erlang buildRebar3 buildHex; };

      # Non hex packages. Examples how to build Rebar/Mix packages with and
      # without helper functions buildRebar3 and buildMix.
      hex = callPackage ./hex { };
      webdriver = callPackage ./webdriver { };
      relxExe = callPackage ../tools/erlang/relx-exe { };
    };
in
makeExtensible packages
