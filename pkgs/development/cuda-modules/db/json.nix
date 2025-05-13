# NOTE: belongs in cudaLib
{
  lib ? import ../../../../lib,
}:
path:

let
  platformsMap = {
    "source".platforms = lib.platforms.all;
    "linux-aarch64".platforms = [ "aarch64-linux" ];
    "linux-all".platforms = lib.platforms.linux;
    "linux-ppc64le".platforms = [ "powerpc64le-linux" ];
    "linux-sbsa".platforms = [ "aarch64-linux" ];
    "linux-x86_64".platforms = [ "x86_64-linux" ];
    "windows-x86_64".platforms = lib.platforms.windows;
  };
  known.platforms = builtins.attrNames platformsMap;
  known.badProducts = [
    "cudnn-v8-9-cuda-12"
    "cudnn-v8-9-cuda-11"
    null
  ];
  known.products = [
    "cuda"
    "cudnn"
    "cutensor"
  ];
  known.toplevel = [
    "release_date"
    "release_label"
    "release_product"
  ];
  looksLikePackage =
    name: p:
    !(builtins.elem name known.toplevel)
    && builtins.isAttrs p
    && builtins.any (lib.flip builtins.elem known.platforms) (builtins.attrNames p);
  licenseOf =
    pname: rawPackage:
    if rawPackage.license != null then
      rawPackage.license
    else if productName == "cuda" then
      lib.licenses.nvidiaCudaRedist.shortName
    else if productName != null then
      productName
    else
      null;
  evaluated = lib.evalModules {
    modules = [
      (builtins.fromJSON (builtins.readFile path))
      (import ../modules/generic/manifests/redistrib/manifest.nix { inherit lib; })
    ];
  };
  raw = evaluated.config;
  concatMapRaw = lib.flip lib.concatMap (lib.attrsToList raw);
  concatMapAttrsRaw = lib.flip lib.concatMapAttrs raw;
  productName =
    if builtins.elem raw.release_product known.badProducts then
      builtins.head (
        lib.optionals (raw.release_product != null)
          # Cf. cudnn circa 8.9 (e.g. cudnn-v8-9-cuda-12)
          (lib.splitString "-" raw.release_product)
        ++ concatMapRaw (
          { name, value }:
          let
            rawPackage = value;
          in
          lib.optionals (looksLikePackage name rawPackage) (
            lib.optionals (builtins.elem name known.products) [
              name
            ]
          )
        )
        ++ [ null ]
      )
    else
      raw.release_product;

  mkDefaultHarder = lib.mkOverride 900;
in
{
  recipes = concatMapAttrsRaw (
    name: rawPackage:
    let
      license = licenseOf name rawPackage;
    in
    lib.optionalAttrs (looksLikePackage name rawPackage) {
      ${name} =
        {
          license = if rawPackage.license != null then license else lib.mkDefault license;
          platforms = lib.genAttrs (builtins.concatMap (
            nv-platform: platformsMap.${nv-platform}.platforms or [ ]
          ) (builtins.attrNames rawPackage)) (_: "");
        }
        // lib.optionalAttrs (rawPackage.name != null) {
          name =
            let
              # Handle inconsistencies like "Imex" v. "Nvidia-Imex"
              prioByLength =
                maxPrio: s:
                lib.mkOverride (lib.modules.defaultOverridePriority - (lib.min maxPrio (lib.stringLength s))) s;
            in
            prioByLength 40 rawPackage.name;
        };
    }
  );
  licenses = concatMapAttrsRaw (
    name: rawPackage:
    let
      shortName = licenseOf name rawPackage;
    in
    lib.optionalAttrs (looksLikePackage name rawPackage && shortName != null) {
      ${shortName} =
        {
          license_path = lib.mkDefault "${name}/LICENSE.txt";
        }
        // lib.optionalAttrs (productName != null) {
          distribution_path = mkDefaultHarder "${productName}/redist/";
        }
        // lib.optionalAttrs (rawPackage.license_path != null) {
          license_path = rawPackage.license_path;
        };
    }
  );
}
