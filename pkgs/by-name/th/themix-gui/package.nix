{ lib
, stdenv
, sassc
, gdk-pixbuf
, glib
, gobject-introspection
, librsvg
, gtk3
, python3
, fetchFromGitHub
, wrapGAppsHook3
}:

let
  py = python3.withPackages (p: [
    p.pygobject3
  ]);
  pname = "themix-gui";
  version = "1.15.1";
in
stdenv.mkDerivation {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "themix-project";
    repo = "themix-gui";
    rev = version;
    hash = "sha256-xFtwNx1c7Atb+9yorZhs/uVkkoxbZiELJ0SZ88L7KMs=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    gobject-introspection
    py
    sassc
    wrapGAppsHook3
  ];

  buildInputs = [
    gdk-pixbuf
    glib
    gtk3
    librsvg
    py
  ];

  postPatch = ''
    substituteInPlace gui.sh packaging/bin/{oomox,themix}-gui --replace python3 ${lib.getExe py}
  '';

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    make DESTDIR=/ APPDIR=$out/opt/oomox PREFIX=$out install_gui install_import_xresources install_export_xresources
    python -O -m compileall $out/opt/oomox/oomox_gui -d /opt/oomox/oomox_gui

    runHook postInstall
  '';

  meta = {
    description = "Graphical application for designing themes and exporting them using plugins";
    longDescription = ''
      Graphical application for generating different color variations of
      Oomox (Numix-based) and Materia (ex-Flat-Plat) themes (GTK2, GTK3,
      Cinnamon, GNOME, Openbox, Xfwm), Archdroid, Gnome-Color, Numix, Papirus
      and Suru++ icon themes. Have a hack for HiDPI in gtk2. Its Base16 plugin
      also allowing a lot of app themes support like Alacritty, Emacs, GTK4,
      KDE, VIM and many more.
    '';
    homepage = "https://github.com/themix-project/themix-gui";
    license = lib.licenses.gpl3Only;
    mainProgram = "themix-gui";
    maintainers = with lib.maintainers; [ ];
    platforms = lib.platforms.linux;
  };
}
