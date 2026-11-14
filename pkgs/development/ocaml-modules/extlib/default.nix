{
  buildDunePackage,
  lib,
  fetchurl,
  cppo,
}:

buildDunePackage (finalAttrs: {
  pname = "extlib";
  version = "1.8.0";

  src = fetchurl {
    url = "https://github.com/ygrek/ocaml-extlib/releases/download/${finalAttrs.version}/extlib-${finalAttrs.version}.tar.gz";
    hash = "sha256-lkJ38AEoCo7d/AjgcB1Zygxr3F0FIxOz5A5QiPbUXXA=";
  };

  nativeBuildInputs = [ cppo ];

  doCheck = true;

  meta = {
    homepage = "https://github.com/ygrek/ocaml-extlib";
    description = "Enhancements to the OCaml Standard Library modules";
    license = lib.licenses.lgpl21Only;
    maintainers = [ lib.maintainers.sternenseemann ];
  };
})
