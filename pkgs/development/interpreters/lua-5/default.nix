# similar to interpreters/python/default.nix
{
  stdenv,
  config,
  lib,
  callPackage,
  fetchFromGitHub,
  fetchurl,
  makeBinaryWrapper,
}:

let

  # Common passthru for all lua interpreters.
  # copied from python
  passthruFun =
    {
      executable,
      luaversion,
      packageOverrides,
      luaOnBuildForBuild,
      luaOnBuildForHost,
      luaOnBuildForTarget,
      luaOnHostForHost,
      luaOnTargetForTarget,
      luaAttr ? null,
      self, # is luaOnHostForTarget
    }:
    let
      luaPackages =
        callPackage
          # Function that when called
          # - imports lua-packages.nix
          # - adds spliced package sets to the package set
          # - applies overrides from `packageOverrides`
          (
            {
              lua,
              overrides,
              callPackage,
              makeScopeWithSplicing',
            }:
            let
              luaPackagesFun = callPackage ../../../top-level/lua-packages.nix {
                lua = self;
              };
              generatedPackages =
                if (builtins.pathExists ../../lua-modules/generated-packages.nix) then
                  (
                    final: prev:
                    callPackage ../../lua-modules/generated-packages.nix { inherit (final) callPackage; } final prev
                  )
                else
                  (final: prev: { });
              overriddenPackages = callPackage ../../lua-modules/overrides.nix { };

              otherSplices = {
                selfBuildBuild = luaOnBuildForBuild.pkgs;
                selfBuildHost = luaOnBuildForHost.pkgs;
                selfBuildTarget = luaOnBuildForTarget.pkgs;
                selfHostHost = luaOnHostForHost.pkgs;
                selfTargetTarget = luaOnTargetForTarget.pkgs or { };
              };

              aliases =
                final: prev:
                lib.optionalAttrs config.allowAliases (import ../../lua-modules/aliases.nix lib final prev);

              extensions = lib.composeManyExtensions [
                aliases
                generatedPackages
                overriddenPackages
                overrides
              ];
            in
            makeScopeWithSplicing' {
              inherit otherSplices;
              f = lib.extends extensions luaPackagesFun;
            }
          )
          {
            overrides = packageOverrides;
            lua = self;
          };
    in
    rec {
      buildEnv = callPackage ./wrapper.nix {
        lua = self;
        makeWrapper = makeBinaryWrapper;
        inherit (luaPackages) requiredLuaModules;
      };
      withPackages = import ./with-packages.nix { inherit buildEnv luaPackages; };
      pkgs = luaPackages;
      interpreter = "${self}/bin/${executable}";
      inherit executable luaversion;
      luaOnBuild = luaOnBuildForHost.override {
        inherit packageOverrides;
        self = luaOnBuild;
      };

      tests = callPackage ./tests {
        lua = self;
        inherit (luaPackages) wrapLua;
      };

      inherit luaAttr;
    };

in

rec {
  lua5_4 = callPackage ./interpreter.nix {
    self = lua5_4;
    version = "5.4.7";
    hash = "sha256-n79eKO+GxphY9tPTTszDLpEcGii0Eg/z6EqqcM+/HjA=";
    makeWrapper = makeBinaryWrapper;
    inherit passthruFun;

    patches = lib.optional stdenv.hostPlatform.isDarwin ./5.4.darwin.patch;
  };

  lua5_4_compat = lua5_4.override {
    self = lua5_4_compat;
    compat = true;
  };

  lua5_3 = callPackage ./interpreter.nix {
    self = lua5_3;
    version = "5.3.6";
    hash = "0q3d8qhd7p0b7a4mh9g7fxqksqfs6mr1nav74vq26qvkp2dxcpzw";
    makeWrapper = makeBinaryWrapper;
    inherit passthruFun;

    patches = lib.optionals stdenv.hostPlatform.isDarwin [ ./5.2.darwin.patch ];
  };

  lua5_3_compat = lua5_3.override {
    self = lua5_3_compat;
    compat = true;
  };

  lua5_2 = callPackage ./interpreter.nix {
    self = lua5_2;
    version = "5.2.4";
    hash = "0jwznq0l8qg9wh5grwg07b5cy3lzngvl5m2nl1ikp6vqssmf9qmr";
    makeWrapper = makeBinaryWrapper;
    inherit passthruFun;
    patches = [
      ./CVE-2022-28805.patch
    ]
    ++ lib.optional stdenv.hostPlatform.isDarwin ./5.2.darwin.patch;
  };

  lua5_2_compat = lua5_2.override {
    self = lua5_2_compat;
    compat = true;
  };

  lua5_1 = callPackage ./interpreter.nix {
    self = lua5_1;
    version = "5.1.5";
    hash = "2640fc56a795f29d28ef15e13c34a47e223960b0240e8cb0a82d9b0738695333";
    makeWrapper = makeBinaryWrapper;
    inherit passthruFun;
    patches = (lib.optional stdenv.hostPlatform.isDarwin ./5.1.darwin.patch) ++ [
      ./CVE-2014-5461.patch
    ];
  };

  luajit_2_0 = import ../luajit/2.0.nix {
    self = luajit_2_0;
    inherit
      callPackage
      fetchFromGitHub
      lib
      passthruFun
      ;
  };

  luajit_2_1 = import ../luajit/2.1.nix {
    self = luajit_2_1;
    inherit callPackage fetchFromGitHub passthruFun;
  };

  luajit_openresty = import ../luajit/openresty.nix {
    self = luajit_openresty;
    inherit callPackage fetchFromGitHub passthruFun;
  };
}
