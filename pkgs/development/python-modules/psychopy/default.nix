{ lib
, buildPythonPackage
, fetchFromGitHub
, pdm-backend
, distro
, tomlkit
, setuptools
, six
, packaging
, numpy
, scipy
, matplotlib
, pyglet
, pillow
, pyqt6
, pandas
#, questplus
, openpyxl
, xmlschema
, soundfile
, imageio
, imageio-ffmpeg
, psychtoolbox
, gevent
, psutil
, pyzmq
, ujson
, msgpack
, msgpack-numpy
, freetype-py
, python-bidi
, arabic-reshaper
, websockets
, wxPython_4_2
, markdown-it-py
, requests
, future
, python-gitlab
, gitpython
, cryptography
, astunparse
, esprima
, jedi
, pyserial
, opencv4
, python-vlc
, xlib
, tables
, javascripthon
, pyparallel
, ffpyplayer
, qt6
, pkg-config
, ffmpeg-full
, glibc
}:

buildPythonPackage rec {
  pname = "psychopy";
  version = "2023.2.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "psychopy";
    repo = "psychopy";
    rev = version;
    hash = "sha256-2sE7CauMe7TlZocBFM/ftsTpSxTifHUyHTqy1rupn9A=";
  };

  nativeBuildInputs = [
    qt6.wrapQtAppsHook
    pkg-config
  ];
  propagatedBuildInputs = [
    pdm-backend
    distro
    tomlkit
    setuptools
    six
    packaging
    numpy
    scipy
    matplotlib
    pyglet
    pillow
    pyqt6
    pandas
    #questplus
    openpyxl
    xmlschema
    soundfile
    imageio
    imageio-ffmpeg
    psychtoolbox
    gevent
    psutil
    pyzmq
    ujson
    msgpack
    msgpack-numpy
    freetype-py
    python-bidi
    arabic-reshaper
    websockets
    wxPython_4_2
    markdown-it-py
    requests
    future
    python-gitlab
    gitpython
    cryptography
    astunparse
    esprima
    jedi
    pyserial
    opencv4
    python-vlc
    xlib
    tables
    javascripthon
    pyparallel
    ffpyplayer

    qt6.qtbase
    ffmpeg-full

    #glibc
    # alredy used in wxPython: wxGTK32 xorg.libXxf86vm pango
  ];

  meta = with lib; {
    homepage = "https://www.psychopy.org";
    description = "An graphical app for creating and running behavioural experiments";
    license = with licenses; [ gpl3Plus ];
    maintainers = with maintainers; [ annaaurora ];
  };
}
