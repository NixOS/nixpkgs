{ stdenv, pkgs, erlang }:

let
  inherit (stdenv.lib) makeExtensible;

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
      } // rec {
        inherit callPackage erlang;
        beamPackages = self;

        hexRegistrySnapshot = callPackage ./hex-registry-snapshot.nix { };

        rebar = callPackage ../tools/build-managers/rebar { };
        rebar3-open = callPackage ../tools/build-managers/rebar3 { };
        rebar3 = callPackage ../tools/build-managers/rebar3 { };

        # rebar3 port compiler plugin is required by buildRebar3
        pc_1_6_0 = callPackage ./pc {};
        pc = pc_1_6_0;

        fetchHex = callPackage ./fetch-hex.nix { };

        fetchRebar3Deps = callPackage ./fetch-rebar-deps.nix { };
        rebar3Relx = callPackage ./rebar3-release.nix { };

        buildRebar3 = callPackage ./build-rebar3.nix {};
        buildHex = callPackage ./build-hex.nix {};
        buildErlangMk = callPackage ./build-erlang-mk.nix {};
        buildMix = callPackage ./build-mix.nix {};

        # BEAM-based languages.
        elixir = elixir_1_7;

        elixir_1_8 = lib.callElixir ../interpreters/elixir/1.8.nix {
          inherit rebar erlang;
          debugInfo = true;
        };

        elixir_1_7 = lib.callElixir ../interpreters/elixir/1.7.nix {
          inherit rebar erlang;
          debugInfo = true;
        };

        elixir_1_6 = lib.callElixir ../interpreters/elixir/1.6.nix {
          inherit rebar erlang;
          debugInfo = true;
        };

        elixir_1_5 = lib.callElixir ../interpreters/elixir/1.5.nix {
          inherit rebar erlang;
          debugInfo = true;
        };

        elixir_1_4 = lib.callElixir ../interpreters/elixir/1.4.nix {
          inherit rebar erlang;
          debugInfo = true;
        };

        # Remove old versions of elixir, when the supports fades out:
        #   https://hexdocs.pm/elixir/compatibility-and-deprecations.html

        lfe = lfe_1_2;
        lfe_1_2 = lib.callLFE ../interpreters/lfe/1.2.nix { inherit erlang buildRebar3 buildHex; };

        # Non hex packages. Examples how to build Rebar/Mix packages with and
        # without helper functions buildRebar3 and buildMix.
        hex = callPackage ./hex {};
        webdriver = callPackage ./webdriver {};
        relxExe = callPackage ../tools/erlang/relx-exe {};

        # The tool used to upgrade hex-packages.nix.
        hex2nix = callPackage ../tools/erlang/hex2nix {};

        # An example of Erlang/C++ package.
        cuter = callPackage ../tools/erlang/cuter {};
      };
in makeExtensible packages
