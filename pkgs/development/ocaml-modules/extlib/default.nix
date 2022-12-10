{ buildDunePackage, lib, fetchurl, cppo }:

buildDunePackage rec {
  pname = "extlib";
  version = "1.7.9";

  minimalOCamlVersion = "4.02";

  src = fetchurl {
    url = "https://ygrek.org/p/release/ocaml-${pname}/${pname}-${version}.tar.gz";
    sha512 = "2386ac69f037ea520835c0624d39ae9fbffe43a20b18e247de032232ed6f419d667b53d2314c6f56dc71d368bf0b6201a56c2f3f2a5bdfd933766c5a6cb98768";
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
