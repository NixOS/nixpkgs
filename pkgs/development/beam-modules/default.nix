{ lib, __splicedPackages, erlang }:

let
  pkgs = __splicedPackages;
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

      pc = callPackage ./pc { };
      rebar3-proper = callPackage ./rebar3-proper { };
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
      erlfmt = callPackage ./erlfmt { };
      elvis-erlang = callPackage ./elvis-erlang { };

      # BEAM-based languages.
      elixir = elixir_1_18;

      elixir_1_18 = lib'.callElixir ../interpreters/elixir/1.18.nix {
        inherit erlang;
        debugInfo = true;
      };

      elixir_1_17 = lib'.callElixir ../interpreters/elixir/1.17.nix {
        inherit erlang;
        debugInfo = true;
      };

      elixir_1_16 = lib'.callElixir ../interpreters/elixir/1.16.nix {
        inherit erlang;
        debugInfo = true;
      };

      elixir_1_15 = lib'.callElixir ../interpreters/elixir/1.15.nix {
        inherit erlang;
        debugInfo = true;
      };

      elixir_1_14 = lib'.callElixir ../interpreters/elixir/1.14.nix {
        inherit erlang;
        debugInfo = true;
      };

      # Remove old versions of elixir, when the supports fades out:
      # https://hexdocs.pm/elixir/compatibility-and-deprecations.html

      ex_doc = callPackage ./ex_doc {
        inherit fetchMixDeps mixRelease;
        elixir = elixir_1_17;
      };

      elixir-ls = callPackage ./elixir-ls { inherit elixir fetchMixDeps mixRelease; };

      lfe = lfe_2_1;
      lfe_2_1 = lib'.callLFE ../interpreters/lfe/2.1.nix { inherit erlang buildRebar3 buildHex; };

      # Non hex packages. Examples how to build Rebar/Mix packages with and
      # without helper functions buildRebar3 and buildMix.
      hex = callPackage ./hex { };
      webdriver = callPackage ./webdriver { };
    };
in
makeExtensible packages
