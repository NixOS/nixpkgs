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
    url = "https://www-verimag.imag.fr/DIST-TOOLS/SYNCHRONE/pool/lutils.v${version}.tgz";
    hash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
  };

  propagatedBuildInputs = [
    camlp-streams
    num
  ];

  meta = with lib; {
    homepage = "https://gricad-gitlab.univ-grenoble-alpes.fr/verimag/synchrone/lutils/";
    description = "Tools and libs shared by Verimag/synchronous tools (lustre, lutin, rdbg)";
    changelog = "https://gricad-gitlab.univ-grenoble-alpes.fr/verimag/synchrone/lutils/-/releases/v${version}";
    license = lib.licenses.cecill21;
    mainProgram = "gnuplot-rif";
  };
}
