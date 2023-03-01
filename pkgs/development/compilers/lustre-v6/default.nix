{ lib, ocamlPackages, fetchurl }:

ocamlPackages.buildDunePackage rec {
  pname = "lustre-v6";
  version = "6.107.3";

  minimalOCamlVersion = "4.12";

  src = fetchurl {
    url = "https://www-verimag.imag.fr/DIST-TOOLS/SYNCHRONE/pool/lustre-v6.v${version}.tgz";
    hash = "sha256-z3cljDyxtotCGUIdYEzYu7fQd04RC3hhWpROcMh6Zng=";
  };

  propagatedBuildInputs = with ocamlPackages; [
    extlib
    lutils
    rdbg
    yaml
  ];

  meta = with lib; {
    description = "Lustre V6 compiler";
    homepage = "https://www-verimag.imag.fr/lustre-v6.html";
    license = licenses.cecill21;
    maintainers = with maintainers; [ delta wegank ];
    mainProgram = "lv6";
  };
}
