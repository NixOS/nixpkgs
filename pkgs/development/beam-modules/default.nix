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
        rebar3-open = callPackage ../tools/build-managers/rebar3 {
          hermeticRebar3 = false;
        };
        rebar3 = callPackage ../tools/build-managers/rebar3 {
          hermeticRebar3 = true;
        };

        # rebar3 port compiler plugin is required by buildRebar3
        pc_1_6_0 = callPackage ./pc {};
        pc = pc_1_6_0;

        fetchHex = callPackage ./fetch-hex.nix { };

        buildRebar3 = callPackage ./build-rebar3.nix {};
        buildHex = callPackage ./build-hex.nix {};
        buildErlangMk = callPackage ./build-erlang-mk.nix {};
        buildMix = callPackage ./build-mix.nix {};

        # BEAM-based languages.
        elixir = elixir_1_7;

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

        elixir_1_3 = lib.callElixir ../interpreters/elixir/1.3.nix {
          inherit rebar erlang;
          debugInfo = true;
        };

        lfe = lfe_1_2;
        lfe_1_2 = lib.callLFE ../interpreters/lfe/1.2.nix { inherit erlang buildRebar3 buildHex; };

        # We list all base hex packages for beam tooling explicitly to ensure
        # tha the tooling does not break during hex-packages.nix updates.
        erlware_commons_1_0_0 = buildHex {
          name    = "erlware_commons";
          version = "1.0.0";
          sha256 = "0wkphbrjk19lxdwndy92v058qwcaz13bcgdzp33h21aa7vminzx7";
          beamDeps = [ cf_0_2_2 ];
        };
        cf_0_2_2 = buildHex {
          name = "cf";
          version = "0.2.2";
          sha256 = "08cvy7skn5d2k4manlx5k3anqgjdvajjhc5jwxbaszxw34q3na28";
        };
        getopt_0_8_2 = buildHex {
          name = "getopt";
          version = "0.8.2";
          sha256 = "1xw30h59zbw957cyjd8n50hf9y09jnv9dyry6x3avfwzcyrnsvkk";
        };

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
