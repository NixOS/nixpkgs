{ buildDunePackage, lib, fetchurl, cppo }:

buildDunePackage rec {
  pname = "extlib";
  version = "1.8.0";

  minimalOCamlVersion = "4.02";

  src = fetchurl {
    url = "https://ygrek.org/p/release/ocaml-${pname}/${pname}-${version}.tar.gz";
    hash = "sha512-3t0rtKY/LfnkUdvmrt4Y2HNImoZ19I3tCRMfKvTQDb6uzIdQA5suT6y59fmxsBxreszTkr+KxaPyyAFWLOXE7g==";
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
