{
  lib,
  buildDunePackage,
  fetchurl,
  stdlib-shims,
}:

buildDunePackage (finalAttrs: {
  pname = "bheap";
  version = "2.0.0";

  src = fetchurl {
    url = "https://github.com/backtracking/bheap/releases/download/${finalAttrs.version}/bheap-${finalAttrs.version}.tbz";
    hash = "sha256-X0PXsje8h7Bwl/YOrisy3mTmRBWDCNozi/FRIBS99jY=";
  };

  doCheck = true;
  checkInputs = [
    stdlib-shims
  ];

  meta = {
    description = "OCaml binary heap implementation by Jean-Christophe Filliâtre";
    license = lib.licenses.lgpl21Only;
    maintainers = [ lib.maintainers.sternenseemann ];
    homepage = "https://github.com/backtracking/bheap";
  };
})
