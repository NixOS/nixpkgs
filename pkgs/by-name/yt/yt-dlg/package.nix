{
  lib,
  python3,
  fetchFromGitHub,
  fetchPypi,
}:
let
  python3Packages =
    (python3.override {
      packageOverrides = final: prev: {
        wxpython = prev.wxpython.overrideAttrs rec {
          version = "4.2.0";
          src = fetchPypi {
            pname = "wxPython";
            inherit version;
            hash = "sha256-ZjzrxFCdfl0RNRiGX+J093+VQ0xdV7w4btWNZc7thsc=";
          };
        };
      };
    }).pkgs;
in
python3Packages.buildPythonApplication rec {
  pname = "yt-dlg";
  version = "1.8.5";

  src = fetchFromGitHub {
    owner = "oleksis";
    repo = "youtube-dl-gui";
    rev = "v${version}";
    hash = "sha256-W1ZlArmM+Ro5MF/rB88me/PD79dJA4v188mPbMd8Kow=";
  };

  pyproject = true;
  build-system = with python3Packages; [
    setuptools
    wheel
  ];
  dependencies = with python3Packages; [
    pypubsub
    wxpython
  ];

  meta = {
    description = "A cross platform front-end GUI of the popular youtube-dl written in wxPython.";
    homepage = "https://oleksis.github.io/youtube-dl-gui";
    license = lib.licenses.unlicense;
    mainProgram = "yt-dlg";
    maintainers = with lib.maintainers; [ quantenzitrone ];
  };
}
