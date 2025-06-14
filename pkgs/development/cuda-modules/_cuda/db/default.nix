let
  lib = import (nixpkgsPath + "/lib");
  inherit (lib) evalModules;

  inherit (import ./nixpkgs_paths.nix)
    cudaPackagesPath
    nixpkgsPath
    ;

  # NOTE: move to cudaLib
  intreeManifests =
    let
      root = cudaPackagesPath;
    in
    lib.concatMap (
      name:
      let
        manifestsDir = root + "/${name}/manifests";
        children = lib.attrsToList (builtins.readDir manifestsDir);
        isManifest = { name, value }: value == "regular" && lib.hasSuffix ".json" name;
        entToPath = { name, ... }: manifestsDir + "/${name}";
        manifests = map entToPath (builtins.filter isManifest children);
      in
      lib.optionals (lib.pathIsDirectory manifestsDir) manifests
    ) (builtins.attrNames (builtins.readDir root));
  jsonToModule = import ./json.nix { inherit lib; };
  ingestTensorrt = import ./ingest_releases_file.nix {
    inherit lib;
    baseUrlAttr = "trt_base_url";
  };
  ingestLegacyCudnn = import ./ingest_releases_file.nix {
    inherit lib;
    baseUrlAttr = "base_url";
  };
  releaseFileModules =
    [
      (ingestTensorrt (cudaPackagesPath + "/tensorrt/releases.nix"))
    ]
    ++ [
      (ingestLegacyCudnn (cudaPackagesPath + "/cudnn/releases.nix"))
    ];
  modulesPath = nixpkgsPath;
in
{
  manifests ? intreeManifests, # :: List Path
  extraModules ? [
    (lib.importJSON ./generated/blobs.json)
    (lib.importJSON ./generated/packages.json)
    (lib.importJSON ./generated/outputs.json)
  ],
  _includeReleaseFiles ? true,
}:
let
  manifestModules = builtins.map jsonToModule manifests;
  evaluated =
    evalModules {
      specialArgs = { inherit modulesPath; };
      modules =
        extraModules
        ++ manifestModules
        ++ lib.optionals _includeReleaseFiles releaseFileModules
        ++ [
          ./schema.nix
        ];
    }
    // {
      inherit intreeManifests;
    };
  errors = builtins.concatMap (
    { assertion, message }: lib.optionals (!assertion) [ message ]
  ) evaluated.config.assertions;
  error = if errors == [ ] then null else lib.concatStringsSep "\n" errors;
in
evaluated
// {
  validConfig =
    assert lib.assertMsg (errors == [ ]) error;
    evaluated.config;
}
