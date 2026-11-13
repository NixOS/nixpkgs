{
  lib,
  python3Packages,
  fetchFromGitHub,
}:

python3Packages.buildPythonApplication {
  pname = "unimatrix";
  version = "0-unstable-2026-05-20";
  pyproject = false;

  src = fetchFromGitHub {
    owner = "will8211";
    repo = "unimatrix";
    rev = "dff519f972103f91384f360f270614184de8aa92";
    hash = "sha256-g5/Hrk/coq8d7pNwE5juMQhxYSZBXwlGbqikiI9eGvg=";
  };

  installPhase = ''
    runHook preInstall

    install -Dm755 ./unimatrix.py $out/bin/unimatrix

    runHook postInstall
  '';

  dontConfigure = true;
  dontBuild = true;

  meta = {
    description = ''Python script to simulate the display from "The Matrix" in terminal'';
    homepage = "https://github.com/will8211/unimatrix";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ anomalocaris ];
    mainProgram = "unimatrix";
  };
}
