{
  lib,
  python3Packages,
  fetchFromGitHub,
  gexiv2,
  gobject-introspection,
  gtk3,
  hicolor-icon-theme,
  intltool,
  libnotify,
  librsvg,
  runtimeShell,
  wrapGAppsHook3,
  fehSupport ? false,
  feh,
  imagemagickSupport ? true,
  imagemagick,
  appindicatorSupport ? true,
  libayatana-appindicator,
  bash,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "variety";
  version = "0.9.0-b1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "varietywalls";
    repo = "variety";
    tag = finalAttrs.version;
    hash = "sha256-uDQZfWY0RuTsdD/IxpjzSTMMtNq632VAwAjB+CeUIbw=";
  };

  nativeBuildInputs = [
    intltool
    wrapGAppsHook3
    gobject-introspection
  ];

  buildInputs = [
    gexiv2
    gtk3
    hicolor-icon-theme
    libnotify
    librsvg
  ]
  ++ lib.optional appindicatorSupport libayatana-appindicator;

  build-system = with python3Packages; [
    setuptools
    setuptools-gettext
  ];

  dependencies =
    with python3Packages;
    [
      beautifulsoup4
      configobj
      dbus-python
      distutils-extra
      httplib2
      lxml
      pillow
      pycairo
      pygobject3
      requests
      setuptools
    ]
    ++ lib.optional fehSupport feh
    ++ lib.optional imagemagickSupport imagemagick;

  doCheck = false;

  # Prevent double wrapping, let the Python wrapper use the args in preFixup.
  dontWrapGApps = true;

  preFixup = ''
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  prePatch = ''
    substituteInPlace variety/VarietyWindow.py \
      --replace-fail '[script,' '["${runtimeShell}", script,' \
      --replace-fail 'check_output(script)' 'check_output(["${runtimeShell}", script])' \
      --replace-fail 'os.stat(path).st_mode | stat.S_IEXEC' 'os.stat(path).st_mode | stat.S_IEXEC | stat.S_IWUSR'
    substituteInPlace data/variety-autostart.desktop.template \
      --replace-fail "/bin/bash" "${lib.getExe bash}" \
      --replace-fail "{VARIETY_PATH}" "variety"
  '';

  postInstall = ''
    mkdir -p $out/share/applications
    intltool-merge --desktop-style po variety.desktop.in $out/share/applications/variety.desktop

    mkdir -p $out/share/icons/hicolor/scalable/apps
    cp variety/data/icons/scalable/apps/variety.svg $out/share/icons/hicolor/scalable/apps/variety.svg
  '';

  pythonImportsCheck = [ "variety" ];

  meta = {
    homepage = "https://github.com/varietywalls/variety";
    description = "Wallpaper manager for Linux systems";
    mainProgram = "variety";
    longDescription = ''
      Variety is a wallpaper manager for Linux systems. It supports numerous
      desktops and wallpaper sources, including local files and online services:
      Flickr, Wallhaven, Unsplash, and more.

      Where supported, Variety sits as a tray icon to allow easy pausing and
      resuming. Otherwise, its desktop entry menu provides a similar set of
      options.

      Variety also includes a range of image effects, such as oil painting and
      blur, as well as options to layer quotes and a clock onto the background.
    '';
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [
      p3psi
      zfnmxt
      willfish
    ];
  };
})
