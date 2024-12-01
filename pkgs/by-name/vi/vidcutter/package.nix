{
  lib,
  fetchFromGitHub,
  ffmpeg,
  mediainfo,
  mpv,
  python3Packages,
  qt5,
}:
let
  version = "6.0.5.3";
in
python3Packages.buildPythonApplication {
  pname = "vidcutter";
  inherit version;

  src = fetchFromGitHub {
    owner = "ozmartian";
    repo = "vidcutter";
    rev = "refs/tags/${version}";
    hash = "sha256-MCltdvXgsZgPh0ezGvWFEa5vZVDBc6r0WxvXSLf4x2Y=";
  };

  pyproject = true;

  nativeBuildInputs = [ qt5.wrapQtAppsHook ];

  buildInputs = [
    mpv
    qt5.qtwayland
  ];

  build-system = with python3Packages; [
    setuptools
  ];

  dependencies = with python3Packages; [
    pyopengl
    pyqt5
    simplejson
  ];

  dontWrapQtApps = true;
  makeWrapperArgs = [
    "\${qtWrapperArgs[@]}"
    "--prefix PATH : ${
      lib.makeBinPath [
        ffmpeg
        mediainfo
      ]
    }"
  ];

  meta = {
    description = "Modern yet simple multi-platform video cutter and joiner";
    longDescription = ''
      A modern, simple to use, constantly evolving and hella fast MEDIA CUTTER + JOINER
      with frame-accurate SmartCut technology, chapter support, media stream selection for audio + subtitle channels
      and blackdetect video filter support to automatically detect scene changes or skip commercials in digital TV recordings.
    '';
    homepage = "https://vidcutter.ozmartians.com/";
    changelog = "https://github.com/ozmartian/vidcutter/blob/master/CHANGELOG";
    license = lib.licenses.gpl3Plus;
    maintainers = [ lib.maintainers.zi3m5f ];
    mainProgram = "vidcutter";
  };
}
