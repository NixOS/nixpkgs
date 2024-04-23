{ config, lib, ... }:
let
  inherit (lib.attrsets) mapAttrs;
  inherit (lib.options) mkOption;
  inherit (lib.trivial) const;
  inherit (lib.types)
    bool
    functionTo
    lazyAttrsOf
    nonEmptyStr
    nullOr
    oneOf
    optionType
    raw
    strMatching
    submodule
    ;
in
{
  options.types = mapAttrs (const mkOption) {
    callPackageOverrider = {
      description = ''
        The option type of a callPackage overrider.

        These are functions which are passed to callPackage, and then provided to overrideAttrs.

        NOTE: The argument provided to overrideAttrs MUST be a function -- if it is not, callPackage will set
        the override attribute on the resulting attribute set, which when provided to overrideAttrs will break
        the package evaluation.
      '';
      type = optionType;
      default =
        let
          overrideAttrsPrevFn = functionTo (lazyAttrsOf raw);
          overrideAttrsFinalPrevFn = functionTo overrideAttrsPrevFn;
        in
        functionTo (oneOf [
          overrideAttrsPrevFn
          overrideAttrsFinalPrevFn
        ]);
    };
    # TODO: Possible improvement for error messages?
    # error: attribute 'deprecationMessage' missing
    #    at /nix/store/djw90qs3g3awfpcd7rhx80017620nm07-source/lib/modules.nix:805:17:
    #       804|       warnDeprecation =
    #       805|         warnIf (opt.type.deprecationMessage != null)
    #          |                 ^
    #       806|           "The type `types.${opt.type.name}' of option `${showOption loc}' defined in ${showFiles opt.declarations} is deprecated. ${opt.type.deprecationMessage}";
    #
    # When we leave off mkOption on cudaCapability, we get that error. However, as `options.types` is defined as a submodule
    # of freeformType = optionType, it should instead provide an error message about how cudaCapability is not a valid option type.
    # NOTE: I can't think of a way to actually improve this error message, because we would need to do type-checking on the options attribute set,
    # not the config attribute set (which is where checks are performed).
    cudaCapability = {
      description = "The option type of a CUDA capability.";
      type = optionType;
      default = strMatching "^[[:digit:]]+\\.[[:digit:]]+[a-z]?$";
    };
    cudatoolkitRunfileRelease = {
      description = "A CUDA runfile release";
      type = optionType;
      default = submodule {
        options = mapAttrs (const mkOption) {
          hash.type = config.types.sriHash;
          url.type = nonEmptyStr;
          version.type = config.types.majorMinorPatchVersion;
        };
      };
    };
    flattenedIndexElem = {
      description = "The option type of an element of a flattened index";
      type = optionType;
      default = submodule {
        options = mapAttrs (const mkOption) {
          cudaVariant.type = config.types.cudaVariant;
          packageInfo.type = config.types.packageInfo;
          packageName.type = config.types.packageName;
          platform.type = config.types.platform;
          redistName.type = config.types.redistName;
          releaseInfo.type = config.types.releaseInfo;
          # NOTE: This is the version of the manifest, not the version of an individual redist package (that is
          # provided by releaseInfo.version).
          version.type = config.types.version;
        };
      };
    };
    gpu = {
      description = "The option type of a GPU";
      type = optionType;
      default = submodule {
        options = mapAttrs (const mkOption) {
          archName.type = nonEmptyStr;
          computeCapability.type = config.types.cudaCapability;
          dontDefaultAfter.type = nullOr config.types.majorMinorVersion;
          isJetson.type = bool;
          maxCudaVersion.type = nullOr config.types.majorMinorVersion;
          minCudaVersion.type = config.types.majorMinorVersion;
        };
      };
    };
    majorVersion = {
      description = "The option type of a version with a single component";
      type = optionType;
      default = config.types.versionWithNumComponents 1;
    };
    majorMinorVersion = {
      description = "The option type of a version with two components";
      type = optionType;
      default = config.types.versionWithNumComponents 2;
    };
    majorMinorPatchVersion = {
      description = "The option type of a version with three components";
      type = optionType;
      default = config.types.versionWithNumComponents 3;
    };
    majorMinorPatchBuildVersion = {
      description = "The option type of a version with four components";
      type = optionType;
      default = config.types.versionWithNumComponents 4;
    };
    nvccCompatibility = {
      description = "The option type of an NVCC compatibility version";
      type = optionType;
      default = submodule {
        options = mapAttrs (const mkOption) {
          clangMaxMajorVersion.type = config.types.majorVersion;
          clangMinMajorVersion.type = config.types.majorVersion;
          gccMaxMajorVersion.type = config.types.majorVersion;
          gccMinMajorVersion.type = config.types.majorVersion;
        };
      };
    };
    versionWithNumComponents = {
      description = "The option type of a version with a specific number of components";
      type = functionTo optionType;
      default =
        numComponents:
        if numComponents < 1 then
          throw "numComponents must be positive"
        else
          strMatching "^[[:digit:]]+(\.[[:digit:]]+){${toString (numComponents - 1)}}$";
    };
  };
}
