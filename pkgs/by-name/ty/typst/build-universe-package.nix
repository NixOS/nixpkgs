{
  lib,
  buildTypstPackage,
  fetchzip,
  typstPackages,
}:
lib.extendMkDerivation {
  inheritFunctionArgs = false;
  constructDrv = buildTypstPackage;

  excludeDrvArgNames = [
    "description"
    "hash"
    "license"
    "homepage"
    "typstDeps"
  ];

  extendDrvArgs =
    finalAttrs:
    {
      pname,
      version,
      description,
      hash,
      license,
      homepage ? null,
      typstDeps ? [ ],
    }:
    {
      src = fetchzip {
        inherit hash;
        url = "https://packages.typst.org/preview/${finalAttrs.pname}-${finalAttrs.version}.tar.gz";
        stripRoot = false;
      };

      typstDeps = builtins.filter (x: x != null) (
        lib.map (d: (lib.attrsets.attrByPath [ d ] null typstPackages)) typstDeps
      );

      meta = {
        inherit description;
        maintainers = with lib.maintainers; [
          cherrypiejam
          RossSmyth
        ];
        license = lib.map (lib.flip lib.getAttr lib.licensesSpdx) license;
      }
      // lib.optionalAttrs (homepage != null) { inherit homepage; };
    };
}
