{ lib, buildDunePackage, fetchurl, num, lutils, ounit}:

buildDunePackage rec {
  pname = "rdbg";
  version = "1.196.12";

  useDune2 = true;

  minimalOCamlVersion = "4.07";

  src = fetchurl {
    url = "http://www-verimag.imag.fr/DIST-TOOLS/SYNCHRONE/pool/rdbg.1.196.12.tgz";
    sha512 = "8e88034b1eda8f1233b4990adc9746782148254c93d8d0c99c246c0d50f306eeb6aa4afcfca8834acb3e268860647f47a24cc6a2d29fb45cac11f098e2ede275";
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
    description = "A programmable debugger that targets reactive programs for which a rdbg-plugin exists. Currently two plugins exist : one for Lustre, and one for Lutin (nb: both are synchronous programming languages)";
    license = lib.licenses.cecill21;
    maintainers = [ lib.maintainers.delta ];
  };
}
