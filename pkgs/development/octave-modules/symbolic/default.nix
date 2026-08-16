{
  buildOctavePackage,
  lib,
  fetchFromGitHub,
  # Octave's Python (Python 3)
  python,
  gnuplot,
  writableTmpDirAsHomeHook,
  makeFontsConf,
  texinfo,
}:

let
  pythonEnv = python.withPackages (ps: [
    ps.sympy
    ps.mpmath
  ]);

in
buildOctavePackage rec {
  pname = "symbolic";
  version = "3.2.1";

  src = fetchFromGitHub {
    owner = "cbm755";
    repo = "octsympy";
    tag = "v${version}";
    hash = "sha256-H2242+1zlke4aLoS3gsHpDfopM5oSZ4IpVR3+xxQ0Dc=";
  };

  propagatedBuildInputs = [ pythonEnv ];

  nativeOctavePkgTestInputs = [
    gnuplot
    writableTmpDirAsHomeHook
    texinfo
  ];

  octavePkgTestEnv.FONTCONFIG_FILE = makeFontsConf { fontDirectories = [ ]; };

  __structuredAttrs = true;

  meta = {
    homepage = "https://gnu-octave.github.io/packages/symbolic/";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ ravenjoad ];
    description = "Adds symbolic calculation features to GNU Octave";
  };
}
