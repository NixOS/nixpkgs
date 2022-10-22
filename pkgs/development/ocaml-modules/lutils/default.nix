{ lib, buildDunePackage, fetchurl, num }:

buildDunePackage rec {
  pname = "lutils";
  version = "1.51.2";

  useDune2 = true;

  minimalOCamlVersion = "4.02";

  src = fetchurl {
    url = "http://www-verimag.imag.fr/DIST-TOOLS/SYNCHRONE/pool/lutils.1.51.2.tgz";
    sha512 = "f94696be379c62e888410ec3d940c888ca4b607cf59c2e364e93a2a694da65ebe6d531107198b795e80eecc3c6865eedb02659c7e7c4e15c9b28d74aa35d09f8";
  };

  propagatedBuildInputs = [
    num
  ];

  meta = with lib; {
    homepage = "https://gricad-gitlab.univ-grenoble-alpes.fr/verimag/synchrone/lutils/";
    description = "Tools and libs shared by Verimag/synchronous tools (lustre, lutin, rdbg)";
    license = lib.licenses.cecill21;
    mainProgram = "gnuplot-rif";
  };
}
