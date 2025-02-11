{
  stdenv,
  lib,
  fetchFromGitLab,
  desktop-file-utils,
  gobject-introspection,
  meson,
  ninja,
  pkg-config,
  wrapGAppsHook3,
  glib,
  gtk3,
  python3,
  xfconf,
  shared-mime-info,
  xdg-utils,
  gitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "catfish";
  version = "4.20.0";

  src = fetchFromGitLab {
    domain = "gitlab.xfce.org";
    owner = "apps";
    repo = "catfish";
    rev = "catfish-${finalAttrs.version}";
    hash = "sha256-7ERE6R714OuqTjeNZw3K6HvQTA8OIglG6+8Kiawwzu8=";
  };

  nativeBuildInputs = [
    desktop-file-utils
    gobject-introspection
    meson
    ninja
    pkg-config
    wrapGAppsHook3
  ];

  buildInputs = [
    glib
    gtk3
    (python3.withPackages (p: [
      p.dbus-python
      p.pygobject3
      p.pexpect
    ]))
    xfconf
  ];

  postPatch = ''
    substituteInPlace catfish/CatfishWindow.py \
      --replace-fail "/usr/share/mime" "${shared-mime-info}/share/mime"
  '';

  preFixup = ''
    # For xdg-mime and xdg-open.
    gappsWrapperArgs+=(--prefix PATH : "${lib.makeBinPath [ xdg-utils ]}")
  '';

  passthru.updateScript = gitUpdater { rev-prefix = "catfish-"; };

  meta = with lib; {
    homepage = "https://docs.xfce.org/apps/catfish/start";
    description = "Handy file search tool";
    mainProgram = "catfish";
    longDescription = ''
      Catfish is a handy file searching tool. The interface is
      intentionally lightweight and simple, using only GTK 3.
      You can configure it to your needs by using several command line
      options.
    '';
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ ] ++ teams.xfce.members;
  };
})
