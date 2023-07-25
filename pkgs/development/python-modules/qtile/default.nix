{ lib
, buildPythonPackage
, fetchFromGitHub
, cairocffi
, dbus-next
, dbus-python
, glib
, libinput
, libxkbcommon
, mpd2
, pango
, pkg-config
, psutil
, pulseaudio
, pygobject3
, python-dateutil
, pywayland
, pywlroots
, pyxdg
, setuptools
, setuptools-scm
, wayland
, wlroots
, xcbutilcursor
, xcffib
, xkbcommon
}:

buildPythonPackage rec {
  pname = "qtile";
  version = "0.22.1";

  src = fetchFromGitHub {
    owner = "qtile";
    repo = "qtile";
    rev = "v${version}";
    hash = "sha256-HOyExVKOqZ4OeNM1/AiXQeiUV+EbSJLEjWEibm07ff8=";
  };

  patches = [
    ./fix-restart.patch # https://github.com/NixOS/nixpkgs/issues/139568
  ];

  postPatch = ''
    substituteInPlace libqtile/pangocffi.py \
      --replace libgobject-2.0.so.0 ${glib.out}/lib/libgobject-2.0.so.0 \
      --replace libpangocairo-1.0.so.0 ${pango.out}/lib/libpangocairo-1.0.so.0 \
      --replace libpango-1.0.so.0 ${pango.out}/lib/libpango-1.0.so.0
    substituteInPlace libqtile/backend/x11/xcursors.py \
      --replace libxcb-cursor.so.0 ${xcbutilcursor.out}/lib/libxcb-cursor.so.0
  '';

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  nativeBuildInputs = [
    pkg-config
    setuptools-scm
    setuptools
  ];

  propagatedBuildInputs = [
    xcffib
    (cairocffi.override { withXcffib = true; })
    python-dateutil
    dbus-python
    dbus-next
    mpd2
    psutil
    pyxdg
    pygobject3
    pywayland
    pywlroots
    xkbcommon
    pulseaudio
  ];

  buildInputs = [
    libinput
    wayland
    wlroots
    libxkbcommon
  ];

  doCheck = false; # Requires X server #TODO this can be worked out with the existing NixOS testing infrastructure.

  meta = with lib; {
    homepage = "http://www.qtile.org/";
    license = licenses.mit;
    description = "A small, flexible, scriptable tiling window manager written in Python";
    platforms = platforms.linux;
    maintainers = with maintainers; [ kamilchm arjan-s ];
  };
}
