{
  config,
  lib,
  pkgs,
  erlang,
  generateSplicesForMkScope,
  makeScopeWithSplicing',
  # Where this package set lives in `pkgs`, so that cross compilation can find
  # its build platform counterpart.
  splicePath,
}:

makeScopeWithSplicing' {
  otherSplices = generateSplicesForMkScope splicePath;
  # This is the set itself, splicing it would recurse.
  keep = self: { inherit (self) beamPackages; };
  f =
    self:
    let
      inherit (self) callPackage;
    in
    {
      inherit erlang;
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
      buildErlangMk = callPackage ./build-erlang-mk.nix { };
      buildMix = callPackage ./build-mix.nix { };
      fetchMixDeps = callPackage ./fetch-mix-deps.nix { };
      mixRelease = callPackage ./mix-release.nix { };

      erlfmt = callPackage ./erlfmt { };
      elvis-erlang = callPackage ./elvis-erlang { };

      # BEAM-based languages.
      elixir = self.elixir_1_18;

      elixir_1_20 = callPackage ../interpreters/elixir/1.20.nix {
        debugInfo = true;
      };

      elixir_1_19 = callPackage ../interpreters/elixir/1.19.nix {
        debugInfo = true;
      };

      elixir_1_18 = callPackage ../interpreters/elixir/1.18.nix {
        debugInfo = true;
      };

      elixir_1_17 = callPackage ../interpreters/elixir/1.17.nix {
        debugInfo = true;
      };

      # Remove old versions of elixir, when the supports fades out:
      # https://hexdocs.pm/elixir/compatibility-and-deprecations.html

      ex_doc = callPackage ./ex_doc { };

      elixir-ls = callPackage ./elixir-ls { };
      expert = callPackage ./expert { };

      lfe = callPackage ../interpreters/lfe { };

      livebook = callPackage ./livebook { };

      # Non hex packages. Examples how to build Rebar/Mix packages with and
      # without helper functions buildRebar3 and buildMix.
      hex = callPackage ./hex { };

      inherit (pkgs.callPackages ./hooks { })
        beamCopySourceHook
        beamModuleInstallHook
        mixBuildDirHook
        mixCompileHook
        mixAppConfigPatchHook
        rebar3CompileHook
        rebarDevendorPatchHook
        ;

    }
    // lib.optionalAttrs config.allowAliases {
      webdriver = throw "'beamPackages.webdriver' has been removed."; # added 2026-07-29
    };

}
