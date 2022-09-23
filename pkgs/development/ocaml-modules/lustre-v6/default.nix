{ lib, buildDunePackage, fetchurl, ocaml_extlib, lutils, rdbg }:

buildDunePackage rec {
  pname = "lustre-v6";
  version = "6.103.3";

  useDune2 = true;

  minimalOCamlVersion = "4.05";

  src = fetchurl {
    url = "http://www-verimag.imag.fr/DIST-TOOLS/SYNCHRONE/pool/lustre-v6.6.103.3.tgz";
    sha512 = "8d452184ee68edda1b5a50717e6a5b13fb21f9204634fc5898280e27a1d79c97a6e7cc04424fc22f34cdd02ed3cc8774dca4f982faf342980b5f9fe0dc1a017d";
  };

  propagatedBuildInputs = [
    ocaml_extlib
    lutils
    rdbg
  ];

  meta = with lib; {
    description = "Lustre V6 compiler";
    homepage = "https://www-verimag.imag.fr/lustre-v6.html";
    license = lib.licenses.cecill21;
    maintainers = [ lib.maintainers.delta ];
    mainProgram = "lv6";
  };
}
