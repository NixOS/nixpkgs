{
  lib,
  python3,
  python3Packages,
  fetchFromGitHub,
}:

python3.pkgs.buildPythonPackage rec {
  pname = "typr";
  rev = "ca2b1dd5d3796904cc83830d245ebe0978ed87c0";
  version = "1.0.1.20";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "DriftingOtter";
    repo = "Typr";
    rev = "${rev}";
    hash = "sha256-agxJs1D+UyU84//JINychrYmH19W31mpMP0wHmrJuIk=";
  };

  build-system = with python3Packages; [ setuptools ];

  dependencies = with python3Packages; [ rich ];

  doCheck = false; # absent

  meta = {
    homepage = "https://github.com/DriftingOtter/Typr";
    description = "Your Personal Typing Tutor";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ artur-sannikov ];
    mainProgram = "typr";
  };
}
