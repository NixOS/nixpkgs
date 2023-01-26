{ lib, buildDunePackage, fetchurl, extlib, lutils, rdbg, yaml }:

buildDunePackage rec {
  pname = "lustre-v6";
  version = "6.107.1";

  minimalOCamlVersion = "4.12";

  src = fetchurl {
    url = "http://www-verimag.imag.fr/DIST-TOOLS/SYNCHRONE/pool/lustre-v6.v${version}.tgz";
    hash = "sha256-EQ+KjDn+UsyHFRh0RWe9toqdjiNcacQUMNRQCLuaw5I=";
  };

  propagatedBuildInputs = [
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
