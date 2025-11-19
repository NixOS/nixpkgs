{
  lib,
  buildTypstPackage,
  fetchzip,
  # typstPackages from within the scope
  packages,
  hash,
  description,
  license,
  typstDeps,
  homepage ? null,
}:
buildTypstPackage (finalAttrs: {
  inherit pname version;

  src = fetchzip {
    inherit hash;
    url = "https://packages.typst.org/preview/${finalAttrs.pname}-${finalAttrs.version}.tar.gz";
    stripRoot = false;
  };

  typstDeps = builtins.filter (x: x != null) (
    lib.map (d: (lib.attrsets.attrByPath [ d ] null packages)) typstDeps
  );

  meta = {
    inherit description;
    maintainers = with lib.maintainers; [ cherrypiejam ];
    license = lib.map (lib.flip lib.getAttr lib.licensesSpdx) license;
  }
  // (if homepage != null then { inherit homepage; } else { });
})
