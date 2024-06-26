{
  lib,
  buildPackages,
  callPackage,
  stdenv,
  nim1,
  nim2,
  nim_builder,
  defaultNimVersion ? 2,
  nimOverrides,
  buildNimPackage,
}:

let
  baseAttrs = {
    strictDeps = true;
    enableParallelBuilding = true;
    doCheck = true;
    configurePhase = ''
      runHook preConfigure
      export NIX_NIM_BUILD_INPUTS=''${pkgsHostTarget[@]} $NIX_NIM_BUILD_INPUTS
      nim_builder --phase:configure
      runHook postConfigure
    '';
    buildPhase = ''
      runHook preBuild
      nim_builder --phase:build
      runHook postBuild
    '';
    checkPhase = ''
      runHook preCheck
      nim_builder --phase:check
      runHook postCheck
    '';
    installPhase = ''
      runHook preInstall
      nim_builder --phase:install
      runHook postInstall
    '';
    meta = {
      inherit (nim2.meta) maintainers platforms;
    };
  };

  fodFromLockEntry =
    let
      methods = {
        fetchzip =
          { url, sha256, ... }:
          buildPackages.fetchzip {
            name = "source";
            inherit url sha256;
          };
        git =
          {
            fetchSubmodules,
            leaveDotGit,
            rev,
            sha256,
            url,
            ...
          }:
          buildPackages.fetchgit {
            inherit
              fetchSubmodules
              leaveDotGit
              rev
              sha256
              url
              ;
          };
      };
    in
    attrs@{ method, ... }:
    let
      fod = methods.${method} attrs;
    in
    ''--path:"${fod.outPath}/${attrs.srcDir}"'';

  asFunc = x: if builtins.isFunction x then x else (_: x);

in
buildNimPackageArgs:
let
  composition =
    finalAttrs:
    let
      postPkg = baseAttrs // (asFunc ((asFunc buildNimPackageArgs) finalAttrs)) baseAttrs;

      lockAttrs = lib.attrsets.optionalAttrs (builtins.hasAttr "lockFile" postPkg) (
        builtins.fromJSON (builtins.readFile postPkg.lockFile)
      );

      lockDepends = lockAttrs.depends or [ ];

      lockFileNimFlags = map fodFromLockEntry lockDepends;

      postNimOverrides = builtins.foldl' (
        prevAttrs:
        { packages, ... }@lockAttrs:
        builtins.foldl' (
          prevAttrs: name:
          if (builtins.hasAttr name nimOverrides) then
            (prevAttrs // (nimOverrides.${name} lockAttrs prevAttrs))
          else
            prevAttrs
        ) prevAttrs packages
      ) postPkg lockDepends;

      finalOverride =
        {
          depsBuildBuild ? [ ],
          nativeBuildInputs ? [ ],
          nimFlags ? [ ],
          requiredNimVersion ? defaultNimVersion,
          passthru ? { },
          ...
        }:
        (
          if requiredNimVersion == 1 then
            {
              depsBuildBuild = [ nim_builder ] ++ depsBuildBuild;
              nativeBuildInputs = [ nim1 ] ++ nativeBuildInputs;
            }
          else if requiredNimVersion == 2 then
            {
              depsBuildBuild = [ nim_builder ] ++ depsBuildBuild;
              nativeBuildInputs = [ nim2 ] ++ nativeBuildInputs;
            }
          else
            throw "requiredNimVersion ${toString requiredNimVersion} is not valid"
        )
        // {
          nimFlags = lockFileNimFlags ++ nimFlags;
          passthru = passthru // {
            # allow overriding the result of buildNimPackageArgs before this composition is applied
            # this allows overriding the lockFile for packages built using buildNimPackage
            # this is adapted from mkDerivationExtensible in stdenv.mkDerivation
            overrideNimAttrs =
              f0:
              let
                f =
                  self: super:
                  let
                    x = f0 super;
                  in
                  if builtins.isFunction x then f0 self super else x;
              in
              buildNimPackage (
                self:
                let
                  super = (asFunc ((asFunc buildNimPackageArgs) self)) baseAttrs;
                in
                super // (if builtins.isFunction f0 || f0 ? __functor then f self super else f0)
              );
          };
        };

      attrs = postNimOverrides // finalOverride postNimOverrides;
    in
    lib.trivial.warnIf (builtins.hasAttr "nimBinOnly" attrs)
      "the nimBinOnly attribute is deprecated for buildNimPackage"
      attrs;

in
stdenv.mkDerivation composition
