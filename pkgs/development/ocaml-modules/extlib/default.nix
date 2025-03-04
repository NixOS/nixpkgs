{
  buildDunePackage,
  lib,
  fetchurl,
  cppo,
}:

buildDunePackage rec {
  pname = "extlib";
  version = "1.8.0";

  src = fetchurl {
    url = "https://github.com/ygrek/ocaml-extlib/releases/download/${version}/extlib-${version}.tar.gz";
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
}
