let
  inherit (import ./nixpkgs_paths.nix) libPath cudaPackagesPath;
in
{
  lib ? import libPath,
}:
path:

let
  inherit (lib) types;
  known.systemsNv = [
    "source"
    "linux-aarch64"
    "linux-all"
    "linux-ppc64le"
    "linux-sbsa"
    "linux-x86_64"
    "windows-x86_64"
  ];
  known.nonSystems = [
    "_recurseForTags" # Added by our JSON-validating modules to indicate presence of `cuda_variant`
    "cuda_variant" # Present in (newer) `cudnn` manifests
    "license"
    "license_path"
    "version"
    "name" # Package's descriptive name
  ];
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
    && builtins.any looksLikeSystem (builtins.attrNames p);
  looksLikeSystem = lib.flip builtins.elem known.systemsNv;
  licenseOf =
    pname: perSystem:
    lib.addErrorContext "while inferring the license of ${pname}" (
      if perSystem.license or null != null then
        perSystem.license
      else if productName == "cuda" then
        lib.licenses.nvidiaCudaRedist.shortName
      else if productName != null then
        productName
      else
        null
    );
  # Handle inconsistencies like "Imex" v. "Nvidia-Imex"
  mkChooseLonger' =
    maxPrio: s:
    lib.mkOverride (lib.modules.defaultOverridePriority - (lib.min maxPrio (lib.stringLength s))) s;
  mkChooseLonger = mkChooseLonger' 40;
  evaluated =
    let
      manifestDecl = cudaPackagesPath + "/modules/generic/manifests/redistrib/manifest.nix";
      featureDecl = cudaPackagesPath + "/modules/generic/manifests/feature/manifest.nix";
    in
    lib.evalModules {
      modules = [
        (lib.importJSON path)
        {
          freeformType = types.submodule {
            imports = [
              (if lib.hasPrefix "feature_" (builtins.baseNameOf path) then featureDecl else manifestDecl)
            ];
          };
          _file = ./json.nix;
        }
      ];
    };
  productName =
    if builtins.elem raw.release_product or null known.badProducts then
      builtins.head (
        lib.optionals (raw.release_product or null != null)
          # Cf. cudnn circa 8.9 (e.g. cudnn-v8-9-cuda-12)
          (lib.splitString "-" raw.release_product)
        ++ concatMapRaw (
          { name, value }:
          let
            rawPackage = value;
          in
          lib.optionals (looksLikePackage name rawPackage) (
            lib.filter (lib.flip builtins.elem known.products) ([ name ] ++ lib.splitString "_" name)
          )
        )
        ++ [ null ]
      )
    else
      raw.release_product;
  releaseLabel = maybeOr (raw.release_label or null) (
    builtins.head (
      lib.take 1 (
        lib.match "^.*_([0-9]{1,2}(\\.[0-9]{1,3}){1,3})\\.json$" (builtins.baseNameOf path) # Forgive me Lord
      )
      ++ lib.optionals (raw ? cuda_cudart) [ raw.cuda_cudart.version or null ]
      ++ [ null ]
    )
  );
  distribution_path = if productName == null then null else "${productName}/redist/";

  raw = evaluated.config;
  concatMapRaw = lib.flip lib.concatMap (lib.attrsToList raw);

  rawPackages = lib.filterAttrs looksLikePackage raw;

  fmapPackages =
    let
      apply = f: { name, value }: f name value;
      fmapAttrsToList = attrs: f: lib.concatMap (apply f) (lib.attrsToList attrs);
    in
    f:
    fmapAttrsToList rawPackages (
      pname: perSystem:
      let
        hasTags = perSystem._recurseForTags or false; # `or false` branch for feature_*.json
        otherAttrs = lib.filterAttrs (name: _: !(looksLikeSystem name)) perSystem;
        # actualSystems = lib.filterAttrs (name: _: !(builtins.elem name known.nonSystems)) perSystem;
        actualSystems = lib.removeAttrs perSystem (lib.attrNames otherAttrs);
        result =
          if hasTags then
            fmapAttrsToList actualSystems (
              systemNv: perTag:
              lib.addErrorContext "while unpacking `${pname}.${systemNv}` as `perTag`" (
                fmapAttrsToList perTag (
                  tag: rawPackage:
                  lib.addErrorContext "while parsing systemNv=${systemNv} tag=${tag} from path=${path}" (
                    f otherAttrs pname systemNv tag rawPackage
                  )
                )
              )
            )
          else
            fmapAttrsToList actualSystems (systemNv: rawPackage: f otherAttrs pname systemNv null rawPackage);
      in
      lib.addErrorContext "while parsing pname=${pname} from path=${path}" result
    );

  mkDefaultHarder = lib.mkOverride 900;
  mkDefaultWeaker = lib.mkOverride 1100;
  pname = lib.mapAttrs (_: _: 1) rawPackages;
  maybeOr = maybe: default: if maybe != null then maybe else default;
in

{ config, ... }:

{
  _file = ./json.nix;
  config = lib.mkMerge (
    (fmapPackages (
      otherAttrs: pname: systemNv: _: rawPackage: [
        {
          package.name.${pname} =
            if otherAttrs ? name then mkChooseLonger otherAttrs.name else lib.mkDefault pname;
        }
      ]
    ))
    ++ (fmapPackages (
      _: pname: systemNv: _: rawPackage:
      lib.optionals (looksLikeSystem systemNv) [
        {
          package.outputs.${pname} =
            lib.filterAttrs (_: enable: enable)
              rawPackage.outputs or { out = true; };
          package.systemsNv.${pname}.${systemNv} = 1;
          system.nvidia.${systemNv} = 1;
        }
      ]
    ))
    ++ lib.optionals (releaseLabel != null) [
      {
        release.product.${productName} = 1;
        release.package.${productName}.${releaseLabel} = { };
      }
    ]
    ++ lib.optionals (releaseLabel != null) (
      fmapPackages (
        otherAttrs: pname: systemNv: tag: rawPackage:
        lib.optionals (looksLikeSystem systemNv && otherAttrs ? version) [
          {
            release.package.${productName}.${releaseLabel} = {
              ${pname} = otherAttrs.version;
            };
            package.version.${pname}.${otherAttrs.version}.${rawPackage.sha256} = 1;
            archive.sha256.${rawPackage.sha256} =
              {
                inherit systemNv;
                url = "${config.base_url}${rawPackage.relative_path}";
              }
              // lib.optionalAttrs (tag != null) {
                extraConstraints =
                  let
                    cudaMajorStr = builtins.head (lib.match "^cuda([0-9]{2})$" tag);
                    cudaMajor = lib.strings.toInt cudaMajorStr;
                  in
                  lib.addErrorContext
                    "while converting `tag` (`${tag}`; `json.nix` only supports tags like `cuda11`, `cuda12`, etc.) to `extraConstraints`"
                    {
                      cuda."<" = toString (cudaMajor + 1);
                      cuda.">=" = cudaMajorStr;
                    };
              };
          }
        ]
      )
    )
    ++ [
      {
        package = {
          inherit pname;
          license =
            let
              licenseWithPriority =
                otherAttrs: pname: systemNv: _: rawPackage:
                let
                  license = licenseOf pname otherAttrs;
                in
                lib.optionals (license != null) [
                  {
                    ${pname} = mkChooseLonger license;
                  }
                ];
            in
            lib.mergeAttrsList (fmapPackages licenseWithPriority);
          overrideLicenseUrl =
            let
              overrideUrl =
                otherAttrs: pname: systemNv: _: _:
                let
                  shortName = licenseOf pname otherAttrs;
                  defined = distribution_path != null && otherAttrs.license_path or null != null;
                  proposal = "${config.base_url}${distribution_path}${otherAttrs.license_path}";
                  needsOverride = proposal != config.license.compiled.${shortName}.url;
                in
                lib.optionals (defined && needsOverride) [
                  {
                    ${pname} = mkDefaultHarder proposal;
                  }
                ];
            in
            lib.mergeAttrsList (fmapPackages overrideUrl);
        };
        license =
          let
            shortNames = lib.concatMapAttrs (
              pname: perSystem:
              let
                shortName = licenseOf pname perSystem;
              in
              lib.optionalAttrs (shortName != null) { ${shortName} = 1; }
            ) rawPackages;
          in
          {
            shortName = shortNames;
            license_path = lib.concatMapAttrs (
              pname: perSystem:
              let
                shortName = licenseOf pname perSystem;
              in
              lib.optionalAttrs (shortName != null) { ${shortName} = mkChooseLonger "${pname}/LICENSE.txt"; }
            ) rawPackages;
            distribution_path = lib.mapAttrs (
              _: _: if distribution_path == null then mkDefaultWeaker null else mkDefaultHarder distribution_path
            ) shortNames;
            compiled = lib.concatMapAttrs (
              pname: perSystem:
              let
                shortName = licenseOf pname perSystem;
              in
              lib.optionalAttrs (shortName != null) {
                ${shortName} = {
                  redistributable = mkDefaultWeaker true;
                };
              }
            ) rawPackages;
          };
      }
    ]
  );
}
