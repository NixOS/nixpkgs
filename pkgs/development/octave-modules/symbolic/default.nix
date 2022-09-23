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

in
buildOctavePackage rec {
  pname = "symbolic";
  version = "3.0.1";

  src = fetchFromGitHub {
    owner = "cbm755";
    repo = "octsympy";
    rev = "v${version}";
    hash = "sha256-FJb5uazqEiyNI6TL9WVewMoQnC3CutcHENl+umNZeto=";
  };

  propagatedBuildInputs = [ pythonEnv ];

  meta = with lib; {
    homepage = "https://octave.sourceforge.io/symbolic/index.html";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ KarlJoad ];
    description = "Adds symbolic calculation features to GNU Octave";
  };
}
