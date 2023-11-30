{ lib
, buildPackages
, callPackage
, stdenv
, nim1
, nim2
, nim_builder
, defaultNimVersion ? 2
, nimOverrides
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
    meta = { inherit (nim2.meta) maintainers platforms; };
  };

  fodFromLockEntry =
    let
      methods = {
        fetchzip = { url, sha256, ... }:
          buildPackages.fetchzip {
            name = "source";
            inherit url sha256;
          };
        git = { fetchSubmodules, leaveDotGit, rev, sha256, url, ... }:
          buildPackages.fetchgit {
            inherit fetchSubmodules leaveDotGit rev sha256 url;
          };
      };
    in
    attrs@{ method, ... }:
    let fod = methods.${method} attrs;
    in ''--path:"${fod.outPath}/${attrs.srcDir}"'';

  callAnnotations = { packages, ... }@lockAttrs:
    map (packageName: nimOverrides.${packageName} or (_: [ ]) lockAttrs)
      packages;

  asFunc = x: if builtins.isFunction x then x else (_: x);

in
buildNimPackageArgs:
let
  composition = finalAttrs:
    let
      postPkg = baseAttrs
        // (asFunc ((asFunc buildNimPackageArgs) finalAttrs)) baseAttrs;

      lockAttrs =
        lib.attrsets.optionalAttrs (builtins.hasAttr "lockFile" postPkg)
          (builtins.fromJSON (builtins.readFile postPkg.lockFile));

      lockDepends = lockAttrs.depends or [ ];

      lockFileNimFlags = map fodFromLockEntry lockDepends;

      annotationOverlays = lib.lists.flatten (map callAnnotations lockDepends);

      postLock = builtins.foldl'
        (prevAttrs: overlay: prevAttrs // (overlay finalAttrs prevAttrs))
        postPkg
        annotationOverlays;

      finalOverride =
        { depsBuildBuild ? [ ]
        , nativeBuildInputs ? [ ]
        , nimFlags ? [ ]
        , requiredNimVersion ? defaultNimVersion
        , ...
        }:
        (if requiredNimVersion == 1 then {
          depsBuildBuild = [ nim_builder ] ++ depsBuildBuild;
          nativeBuildInputs = [ nim1 ] ++ nativeBuildInputs;
        } else if requiredNimVersion == 2 then {
          depsBuildBuild = [ nim_builder ] ++ depsBuildBuild;
          nativeBuildInputs = [ nim2 ] ++ nativeBuildInputs;
        } else
          throw
            "requiredNimVersion ${toString requiredNimVersion} is not valid") // {
          nimFlags = lockFileNimFlags ++ nimFlags;
        };

      attrs = postLock // finalOverride postLock;
    in
    lib.trivial.warnIf (builtins.hasAttr "nimBinOnly" attrs)
      "the nimBinOnly attribute is deprecated for buildNimPackage"
      attrs;

in
stdenv.mkDerivation composition
