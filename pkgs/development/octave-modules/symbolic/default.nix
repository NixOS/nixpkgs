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
buildOctavePackage {
  pname = "symbolic";
  version = "3.2.2";

  src = fetchFromGitHub {
    owner = "cbm755";
    repo = "octsympy";
    rev = "0206197f77f6663720a0510c761110abeb2041cd";
    hash = "sha256-P9E0ZgB06Y/bvYCWD7W9kYZVWfZPWyBKnXw+X5H4yLI=";
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
