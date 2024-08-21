{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  cairocffi,
  dbus-next,
  glib,
  iwlib,
  libcst,
  libdrm,
  libinput,
  libxkbcommon,
  mpd2,
  pango,
  pixman,
  pkg-config,
  psutil,
  pulsectl-asyncio,
  pygobject3,
  pytz,
  pywayland,
  pywlroots,
  pyxdg,
  setuptools,
  setuptools-scm,
  wayland,
  wlroots,
  xcbutilcursor,
  xcbutilwm,
  xcffib,
  xkbcommon,
  nixosTests,
  extraPackages ? [ ],
}:

buildPythonPackage rec {
  pname = "qtile";
  version = "0.28.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "qtile";
    repo = "qtile";
    rev = "refs/tags/v${version}";
    hash = "sha256-r8cAht40r1/6rG1xrfx34YEPuPeyBCuSvX7MarLTTCc=";
  };

  patches = [
    ./fix-restart.patch # https://github.com/NixOS/nixpkgs/issues/139568
  ];

  postPatch = ''
    substituteInPlace libqtile/pangocffi.py \
      --replace-fail libgobject-2.0.so.0 ${glib.out}/lib/libgobject-2.0.so.0 \
      --replace-fail libpangocairo-1.0.so.0 ${pango.out}/lib/libpangocairo-1.0.so.0 \
      --replace-fail libpango-1.0.so.0 ${pango.out}/lib/libpango-1.0.so.0
    substituteInPlace libqtile/backend/x11/xcursors.py \
      --replace-fail libxcb-cursor.so.0 ${xcbutilcursor.out}/lib/libxcb-cursor.so.0
    substituteInPlace libqtile/backend/wayland/cffi/build.py \
        --replace-fail /usr/include/pixman-1 ${lib.getDev pixman}/include \
        --replace-fail /usr/include/libdrm ${lib.getDev libdrm}/include/libdrm
  '';

  build-system = [
    setuptools
    setuptools-scm
    pkg-config
  ];

  dependencies = extraPackages ++ [
    (cairocffi.override { withXcffib = true; })
    dbus-next
    iwlib
    libcst
    mpd2
    psutil
    pulsectl-asyncio
    pygobject3
    pytz
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

  postInstall = ''
    install resources/qtile.desktop -Dt $out/share/xsessions
    install resources/qtile-wayland.desktop -Dt $out/share/wayland-sessions
  '';

  meta = with lib; {
    homepage = "http://www.qtile.org/";
    license = licenses.mit;
    description = "Small, flexible, scriptable tiling window manager written in Python";
    mainProgram = "qtile";
    platforms = platforms.linux;
    maintainers = with maintainers; [
      arjan-s
      sigmanificient
    ];
  };
}
