{ buildDunePackage, lib, fetchurl, cppo }:

buildDunePackage rec {
  pname = "extlib";
  version = "1.7.9";

  minimalOCamlVersion = "4.02";

  src = fetchurl {
    url = "https://ygrek.org/p/release/ocaml-${pname}/${pname}-${version}.tar.gz";
    hash = "sha512-I4asafA36lIINcBiTTmun7/+Q6ILGOJH3gMiMu1vQZ1me1PSMUxvVtxx02i/C2IBpWwvPypb39kzdmxabLmHaA==";
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
