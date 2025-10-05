{
  lib,
  fetchurl,
  fetchpatch,
  nix-update-script,
  python3Packages,
  gdk-pixbuf,
  glib,
  adwaita-icon-theme,
  gobject-introspection,
  gtk3,
  wrapGAppsHook3,
  webkitgtk_4_1,
  libnotify,
  keybinder3,
  libappindicator,
  intltool,
  wmctrl,
  xvfb-run,
  librsvg,
  libX11,
  copyDesktopItems,
  makeDesktopItem,
}:

python3Packages.buildPythonApplication rec {
  pname = "ulauncher";
  version = "5.15.7";
  pyproject = true;

  src = fetchurl {
    url = "https://github.com/Ulauncher/Ulauncher/releases/download/${version}/ulauncher_${version}.tar.gz";
    hash = "sha256-YgOw3Gyy/o8qorWAnAlQrAZ2ZTnyP3PagLs2Qkdg788=";
  };

  nativeBuildInputs = [
    gobject-introspection
    intltool
    wrapGAppsHook3
    gdk-pixbuf
    copyDesktopItems
  ];

  buildInputs = [
    glib
    adwaita-icon-theme
    gtk3
    keybinder3
    libappindicator
    libnotify
    librsvg
    webkitgtk_4_1
    wmctrl
  ];

  build-system = with python3Packages; [
    setuptools
    distutils-extra
  ];

  dependencies = with python3Packages; [
    mock
    dbus-python
    pygobject3
    pyinotify
    levenshtein
    pyxdg
    pycairo
    requests
    semver
    websocket-client
  ];

  nativeCheckInputs = with python3Packages; [
    mock
    pytest
    pytest-mock
    xvfb-run
  ];

  patches = [
    ./fix-path.patch
    ./fix-extensions.patch
    (fetchpatch {
      name = "support-gir1.2-webkit2-4.1.patch";
      url = "https://src.fedoraproject.org/rpms/ulauncher/raw/rawhide/f/support-gir1.2-webkit2-4.1.patch";
      hash = "sha256-w1c+Yf6SA3fyMrMn1LXzCXf5yuynRYpofkkUqZUKLS8=";
    })
  ];

  postPatch = ''
    substituteInPlace setup.py --subst-var out
    patchShebangs bin/ulauncher-toggle
    substituteInPlace bin/ulauncher-toggle \
      --replace-fail wmctrl ${wmctrl}/bin/wmctrl
  '';

  # https://github.com/Ulauncher/Ulauncher/issues/390
  doCheck = false;

  preCheck = ''
    export PYTHONPATH=$PYTHONPATH:$out/${python3Packages.python.sitePackages}
  '';

  # Simple translation of
  # - https://github.com/Ulauncher/Ulauncher/blob/f5a601bdca75198a6a31b9d84433496b63530e74/test
  checkPhase = ''
    runHook preCheck

    # skip tests in invocation that handle paths that
    # aren't nix friendly (i think)
    xvfb-run -s '-screen 0 1024x768x16' \
      pytest -k 'not TestPath and not test_handle_key_press_event' tests

    runHook postCheck
  '';

  pythonImportsCheck = [ "ulauncher" ];

  # do not double wrap
  dontWrapGApps = true;
  preFixup = ''
    makeWrapperArgs+=(
     "''${gappsWrapperArgs[@]}"
     --prefix PATH : "${lib.makeBinPath [ wmctrl ]}"
     --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath [ libX11 ]}"
     --prefix WEBKIT_DISABLE_COMPOSITING_MODE : "1"
    )
  '';

  passthru = {
    updateScript = nix-update-script { };
  };

  desktopItems = [
    (makeDesktopItem {
      name = "ulauncher";
      desktopName = "Ulauncher";
      exec = "ulauncher";
      categories = [ "Utility" ];
      icon = "ulauncher";
    })
  ];

  meta = with lib; {
    description = "Fast application launcher for Linux, written in Python, using GTK";
    homepage = "https://ulauncher.io/";
    license = licenses.gpl3;
    platforms = platforms.linux;
    mainProgram = "ulauncher";
    maintainers = with maintainers; [
      aaronjanse
    ];
  };
}
