{
  lib,
  python3,
  fetchFromGitHub,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "syrics";
  version = "0.1.2.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "akashrchandran";
    repo = "syrics";
    tag = "v${version}";
    hash = "sha256-udW6i3nRWECXpQGGGK2U8QVRJVrsHeqjDK8QCMH5I8s=";
  };

  build-system = [
    python3.pkgs.setuptools
    python3.pkgs.wheel
  ];

  dependencies = with python3.pkgs; [
    requests
    spotipy
    tinytag
    tqdm
  ];

  pythonImportsCheck = [
    "syrics"
  ];

  meta = {
    description = "Command line tool to fetch lyrics from spotify and save it to lrc file";
    homepage = "https://github.com/akashrchandran/syrics/";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ yogansh ];
    mainProgram = "syrics";
  };
}
