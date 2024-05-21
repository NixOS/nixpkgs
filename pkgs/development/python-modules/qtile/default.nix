{ lib
, buildPythonPackage
, fetchFromGitHub
, cairocffi
, dbus-next
, dbus-python
, glib
, iwlib
, libdrm
, libinput
, libxkbcommon
, mpd2
, pango
, pixman
, pkg-config
, psutil
, pulsectl-asyncio
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
, xcbutilwm
, xcffib
, xkbcommon
, nixosTests
}:

buildPythonPackage rec {
  pname = "qtile";
  version = "0.25.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "qtile";
    repo = "qtile";
    rev = "refs/tags/v${version}";
    hash = "sha256-j5hpXfUSDUT9nBr6CafIzqdTYQxSWok+ZlQA7bGdVvk=";
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
    substituteInPlace libqtile/backend/wayland/cffi/build.py \
        --replace /usr/include/pixman-1 ${lib.getDev pixman}/include \
        --replace /usr/include/libdrm ${lib.getDev libdrm}/include/libdrm
  '';

  build-system = [
    setuptools
    setuptools-scm
    pkg-config
  ];

  dependencies = [
    (cairocffi.override { withXcffib = true; })
    dbus-next
    dbus-python
    iwlib
    mpd2
    psutil
    pulsectl-asyncio
    pygobject3
    python-dateutil
    pywayland
    pywlroots
    pyxdg
    xcffib
    xkbcommon
  ];

  buildInputs = [
    libinput
    libxkbcommon
    wayland
    wlroots
    xcbutilwm
  ];

  doCheck = false;
  passthru = {
    tests.qtile = nixosTests.qtile;
    providedSessions = [ "qtile" ];
  };

  meta = with lib; {
    homepage = "http://www.qtile.org/";
    license = licenses.mit;
    description = "A small, flexible, scriptable tiling window manager written in Python";
    mainProgram = "qtile";
    platforms = platforms.linux;
    maintainers = with maintainers; [ arjan-s sigmanificient ];
  };
}
