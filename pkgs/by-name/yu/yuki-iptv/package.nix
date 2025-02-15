{
  bash,
  fetchFromGitea,
  ffmpeg,
  gettext,
  lib,
  mpv-unwrapped,
  python3Packages,
  qt6,
  python3
}:

python3Packages.buildPythonApplication rec {
  pname = "yuki-iptv";
  version = "0.0.15";
  pyproject = false;

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "liya";
    repo = "yuki-iptv";
    rev = "refs/tags/${version}";
    hash = "sha256-fejAKHvJVDz/UfzAlPbKHQfJTOLy+HY9LfsDgO8vyAU=";
  };

  buildInputs = [
    ffmpeg
    mpv-unwrapped
    qt6.qtbase
  ];

  nativeBuildInputs = [
    gettext
    qt6.wrapQtAppsHook
  ];

  dependencies = with python3.pkgs; [
    chardet
    pygobject3
    pyqt6
    pyqt6-sip
    requests
    setproctitle
    unidecode
    wand
  ];

  postPatch = ''
    substituteInPlace usr/lib/yuki-iptv/yuki-iptv.py \
      --replace __DEB_VERSION__ ${version}

    substituteInPlace usr/lib/yuki-iptv/thirdparty/mpv.py \
      --replace "ctypes.util.find_library('mpv')" "'${lib.getLib mpv-unwrapped}/lib/libmpv.so'"

    substituteInPlace usr/bin/yuki-iptv \
      --replace "#!/bin/sh" "#!${bash}/bin/sh" \
      --replace "python3" "${python3}/bin/python3"
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cp -r usr/* $out

    runHook postInstall
  '';

  meta = {
    description = "IPTV player with EPG support";
    license = lib.licenses.cc-by-40;
    platforms = lib.platforms.linux;
    homepage = "https://codeberg.org/liya/yuki-iptv";
  };
}
