{
  buildOctavePackage,
  lib,
  fetchFromGitHub,
  # Octave's Python (Python 3)
  python,
}:

let
  pythonEnv = python.withPackages (ps: [
    ps.sympy
    ps.mpmath
  ]);

in
buildOctavePackage rec {
  pname = "symbolic";
  version = "3.2.2";

  src = fetchFromGitHub {
    owner = "cbm755";
    repo = "octsympy";
    tag = "v${version}";
    hash = "sha256-7SrTLb2DNeBIDC3yHRs+/ttSR/tCDhBD9lXCHuue6fw=";
  };

  propagatedBuildInputs = [ pythonEnv ];

  meta = {
    homepage = "https://gnu-octave.github.io/packages/symbolic/";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ KarlJoad ];
    description = "Adds symbolic calculation features to GNU Octave";
  };
}
