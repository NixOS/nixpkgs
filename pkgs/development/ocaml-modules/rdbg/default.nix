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
    url = "http://www-verimag.imag.fr/DIST-TOOLS/SYNCHRONE/pool/rdbg.v${version}.tgz";
    hash = "sha512:6076eaa3608a313f8ac71a4f5aa4fcc64aeb0c646d581e5035110d4c80f94de34f2ba26f90a9a1e92a7f788c9e799f1f7b0e3728c853a21983ad732f0ee60352";
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
