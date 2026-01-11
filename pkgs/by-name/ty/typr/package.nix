{
  lib,
  python3Packages,
  fetchFromGitHub,
}:

python3Packages.buildPythonApplication rec {
  pname = "typr";
  version = "1.0.1.21";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "DriftingOtter";
    repo = "Typr";
    tag = version;
    hash = "sha256-49e5tnX/vea3xLJP62Sj2gCdjbfsulIU48X/AR/3IBI=";
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
