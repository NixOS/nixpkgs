{
  lib,
  python3,
  fetchFromGitHub,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "syncrclone";
  version = "0-unstable-2023-03-23";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jwink3101";
    repo = "syncrclone";
    rev = "137c9c4cc737a383b23cd9a5a21bb079e6a8fc59";
    hash = "sha256-v81hPeu5qnMG6Sb95D88jy5x/GO781bf7efCYjbOaxs=";
  };

  build-system = with python3.pkgs; [ setuptools ];

  pythonImportsCheck = [
    "syncrclone"
  ];

  meta = with lib; {
    description = "Bidirectional sync tool for rclone";
    homepage = "https://github.com/Jwink3101/syncrclone";
    changelog = "https://github.com/Jwink3101/syncrclone/blob/${src.rev}/docs/changelog.md";
    sourceProvenance = with sourceTypes; [ fromSource ];
    license = licenses.mit;
    maintainers = with maintainers; [ prominentretail ];
    mainProgram = "syncrclone";
  };
}
