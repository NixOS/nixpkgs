{ lib
, python3Packages
, fetchFromGitHub
}:

python3Packages.buildPythonApplication rec {
  pname = "unimatrix";
  version = "unstable-2023-04-25";
  pyproject = false;

  src = fetchFromGitHub {
    owner = "will8211";
    repo = pname;
    rev = "65793c237553bf657af2f2248d2a2dc84169f5c4";
    hash = "sha256-fiaVEc0rtZarUQlUwe1V817qWRx4LnUyRD/j2vWX5NM=";
  };

  installPhase = ''
    runHook preInstall

    install -Dm755 ./unimatrix.py $out/bin/unimatrix

    runHook postInstall
  '';

  dontConfigure = true;
  dontBuild = true;

  meta = with lib; {
    description = ''Python script to simulate the display from "The Matrix" in terminal'';
    homepage = "https://github.com/will8211/unimatrix";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ anomalocaris ];
    mainProgram = "unimatrix";
  };
}
