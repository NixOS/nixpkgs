{ buildOctavePackage
, lib
, fetchFromGitHub
# Octave's Python (Python 3)
, python
}:

let
  pythonEnv = python.withPackages (ps: [
      ps.sympy
      ps.mpmath
    ]);

in buildOctavePackage rec {
  pname = "symbolic";
  version = "unstable-2021-10-16";

  # https://github.com/cbm755/octsympy/issues/1023 has been resolved, however
  # a new release has not been made
  src = fetchFromGitHub {
    owner = "cbm755";
    repo = "octsympy";
    rev = "5b58530f4ada78c759829ae703a0e5d9832c32d4";
    sha256 = "sha256-n6P1Swjl4RfgxfLY0ZuN3pcL8PcoknA6yxbnw96OZ2k=";
  };

  propagatedBuildInputs = [ pythonEnv ];

  meta = with lib; {
    homepage = "https://octave.sourceforge.io/symbolic/index.html";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ KarlJoad ];
    description = "Adds symbolic calculation features to GNU Octave";
  };
}
