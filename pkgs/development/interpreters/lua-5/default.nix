# similar to interpreters/python/default.nix
{ stdenv, lib, callPackage, fetchurl, fetchpatch, makeBinaryWrapper }:


let

  # Common passthru for all lua interpreters.
  # copied from python
  passthruFun =
    { executable
    , sourceVersion
    , luaversion
    , packageOverrides
    , luaOnBuildForBuild
    , luaOnBuildForHost
    , luaOnBuildForTarget
    , luaOnHostForHost
    , luaOnTargetForTarget
    , luaAttr ? null
    , self # is luaOnHostForTarget
    }: let
      luaPackages = callPackage
        # Function that when called
        # - imports lua-packages.nix
        # - adds spliced package sets to the package set
        # - applies overrides from `packageOverrides`
        ({ lua, overrides, callPackage, splicePackages, newScope }: let
          luaPackagesFun = callPackage ../../../top-level/lua-packages.nix {
            lua = self;
          };
          generatedPackages = if (builtins.pathExists ../../lua-modules/generated-packages.nix) then
            (final: prev: callPackage ../../lua-modules/generated-packages.nix { inherit (final) callPackage; } final prev)
          else (final: prev: {});
          overridenPackages = callPackage ../../lua-modules/overrides.nix { };

          otherSplices = {
            selfBuildBuild = luaOnBuildForBuild.pkgs;
            selfBuildHost = luaOnBuildForHost.pkgs;
            selfBuildTarget = luaOnBuildForTarget.pkgs;
            selfHostHost = luaOnHostForHost.pkgs;
            selfTargetTarget = luaOnTargetForTarget.pkgs or {};
          };
          keep = self: { };
          extra = spliced0: {};
          extensions = lib.composeManyExtensions [
            generatedPackages
            overridenPackages
            overrides
          ];
        in lib.makeScopeWithSplicing
          splicePackages
          newScope
          otherSplices
          keep
          extra
          (lib.extends extensions luaPackagesFun))
        {
          overrides = packageOverrides;
          lua = self;
        };
    in rec {
        buildEnv = callPackage ./wrapper.nix {
          lua = self;
          inherit (luaPackages) requiredLuaModules;
        };
        withPackages = import ./with-packages.nix { inherit buildEnv luaPackages;};
        pkgs = luaPackages;
        interpreter = "${self}/bin/${executable}";
        inherit executable luaversion sourceVersion;
        luaOnBuild = luaOnBuildForHost.override { inherit packageOverrides; self = luaOnBuild; };

        inherit luaAttr;
  };

in

rec {
  lua5_4 = callPackage ./interpreter.nix {
    self = lua5_4;
    sourceVersion = { major = "5"; minor = "4"; patch = "3"; };
    hash = "1yxvjvnbg4nyrdv10bq42gz6dr66pyan28lgzfygqfwy2rv24qgq";
    makeWrapper = makeBinaryWrapper;
    inherit passthruFun;

    patches = lib.optional stdenv.isDarwin ./5.4.darwin.patch
      ++ [
        (fetchpatch {
          name = "CVE-2022-28805.patch";
          url = "https://github.com/lua/lua/commit/1f3c6f4534c6411313361697d98d1145a1f030fa.patch";
          sha256 = "sha256-YTwoolSnRNJIHFPVijSO6ZDw35BG5oWYralZ8qOb9y8=";
          stripLen = 1;
          extraPrefix = "src/";
          excludes = [ "src/testes/*" ];
        })
        (fetchpatch {
          name = "CVE-2022-33099.patch";
          url = "https://github.com/lua/lua/commit/42d40581dd919fb134c07027ca1ce0844c670daf.patch";
          sha256 = "sha256-qj1Dq1ojVoknALSa67jhgH3G3Kk4GtJP6ROFElVF+D0=";
          stripLen = 1;
          extraPrefix = "src/";
        })
      ];
  };

  lua5_4_compat = lua5_4.override({
    self = lua5_4_compat;
    compat = true;
  });

  lua5_3 = callPackage ./interpreter.nix {
    self = lua5_3;
    sourceVersion = { major = "5"; minor = "3"; patch = "6"; };
    hash = "0q3d8qhd7p0b7a4mh9g7fxqksqfs6mr1nav74vq26qvkp2dxcpzw";
    makeWrapper = makeBinaryWrapper;
    inherit passthruFun;

    patches =
      lib.optionals stdenv.isDarwin [ ./5.2.darwin.patch ];
  };

  lua5_3_compat = lua5_3.override({
    self = lua5_3_compat;
    compat = true;
  });


  lua5_2 = callPackage ./interpreter.nix {
    self = lua5_2;
    sourceVersion = { major = "5"; minor = "2"; patch = "4"; };
    hash = "0jwznq0l8qg9wh5grwg07b5cy3lzngvl5m2nl1ikp6vqssmf9qmr";
    makeWrapper = makeBinaryWrapper;
    inherit passthruFun;
    patches = [
      ./CVE-2022-28805.patch
    ] ++ lib.optional stdenv.isDarwin ./5.2.darwin.patch;
  };

  lua5_2_compat = lua5_2.override({
    self = lua5_2_compat;
    compat = true;
  });


  lua5_1 = callPackage ./interpreter.nix {
    self = lua5_1;
    sourceVersion = { major = "5"; minor = "1"; patch = "5"; };
    hash = "2640fc56a795f29d28ef15e13c34a47e223960b0240e8cb0a82d9b0738695333";
    makeWrapper = makeBinaryWrapper;
    inherit passthruFun;
    patches = (lib.optional stdenv.isDarwin ./5.1.darwin.patch)
      ++ [ ./CVE-2014-5461.patch ];
  };

  luajit_2_0 = import ../luajit/2.0.nix {
    self = luajit_2_0;
    inherit callPackage lib passthruFun;
  };

  luajit_2_1 = import ../luajit/2.1.nix {
    self = luajit_2_1;
    inherit callPackage passthruFun;
  };

}
