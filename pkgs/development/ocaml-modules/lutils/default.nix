{
  lib,
  buildDunePackage,
  fetchurl,
  camlp-streams,
  num,
}:

buildDunePackage rec {
  pname = "lutils";
  version = "1.54.1";

  minimalOCamlVersion = "4.02";

  src = fetchurl {
    url = "http://www-verimag.imag.fr/DIST-TOOLS/SYNCHRONE/pool/lutils.v${version}.tgz";
    hash = "sha512:d3c3b80286b1aa236ba922d9e18a133721fc80126c8b89520fb811dce9400e217aaa75b5d49e03988be7f6bf5f2e1a391d02ceeaa5ec0a0cd5ce218083a29514";
  };

  propagatedBuildInputs = [
    camlp-streams
    num
  ];

  meta = {
    homepage = "https://gricad-gitlab.univ-grenoble-alpes.fr/verimag/synchrone/lutils/";
    description = "Tools and libs shared by Verimag/synchronous tools (lustre, lutin, rdbg)";
    changelog = "https://gricad-gitlab.univ-grenoble-alpes.fr/verimag/synchrone/lutils/-/releases/v${version}";
    license = lib.licenses.cecill21;
    mainProgram = "gnuplot-rif";
  };
}
