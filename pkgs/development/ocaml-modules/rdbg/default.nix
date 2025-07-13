{
  lib,
  buildDunePackage,
  fetchurl,
  num,
  lutils,
  ounit,
}:

buildDunePackage rec {
  pname = "rdbg";
  version = "1.199.0";

  minimalOCamlVersion = "4.08";

  src = fetchurl {
    url = "https://www-verimag.imag.fr/DIST-TOOLS/SYNCHRONE/pool/rdbg.v${version}.tgz";
    hash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
  };

  buildInputs = [
    num
    ounit
  ];

  propagatedBuildInputs = [
    lutils
  ];

  meta = with lib; {
    homepage = "https://gricad-gitlab.univ-grenoble-alpes.fr/verimag/synchrone/rdbg";
    description = "Programmable debugger that targets reactive programs for which a rdbg-plugin exists. Currently two plugins exist : one for Lustre, and one for Lutin (nb: both are synchronous programming languages)";
    license = lib.licenses.cecill21;
    maintainers = [ lib.maintainers.delta ];
  };
}
