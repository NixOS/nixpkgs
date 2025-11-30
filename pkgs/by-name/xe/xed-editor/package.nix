{
  stdenv,
  lib,
  fetchFromGitHub,
  fetchpatch,
  libxml2,
  libpeas,
  glib,
  gtk3,
  gtksourceview4,
  gspell,
  xapp,
  xapp-symbolic-icons,
  pkg-config,
  python3,
  meson,
  ninja,
  versionCheckHook,
  wrapGAppsHook3,
  intltool,
  itstool,
}:

stdenv.mkDerivation rec {
  pname = "xed-editor";
  version = "3.8.5";

  src = fetchFromGitHub {
    owner = "linuxmint";
    repo = "xed";
    rev = version;
    hash = "sha256-iPD9SawHA0bwnZvC+IyMq9cFE1YOYLISehUJjTXiqGw=";
  };

  patches = [
    # We patch gobject-introspection and meson to store absolute paths to libraries in typelibs
    # but that requires the install_dir is an absolute path.
    ./correct-gir-lib-path.patch

    # Switch to girepository-2.0
    (fetchpatch {
      url = "https://src.fedoraproject.org/rpms/xed/raw/6c1a775158f166a3bc5759a6c7bd57bab8f2771a/f/libpeas_libgirepository2.patch";
      hash = "sha256-wGbmS33YHMiSfd3S0fQRhL6tT536kto69MSgPkY2QIs=";
    })
  ];

  nativeBuildInputs = [
    meson
    pkg-config
    intltool
    itstool
    ninja
    python3
    versionCheckHook
    wrapGAppsHook3
  ];

  buildInputs = [
    libxml2
    glib
    gtk3
    gtksourceview4
    libpeas
    gspell
    xapp
  ];

  preFixup = ''
    gappsWrapperArgs+=(
      --prefix XDG_DATA_DIRS : "${lib.makeSearchPath "share" [ xapp-symbolic-icons ]}"
    )
  '';

  doInstallCheck = true;
  versionCheckProgram = "${placeholder "out"}/bin/xed";

  meta = with lib; {
    description = "Light weight text editor from Linux Mint";
    homepage = "https://github.com/linuxmint/xed";
    license = licenses.gpl2Only;
    platforms = platforms.linux;
    maintainers = with maintainers; [
      tu-maurice
      bobby285271
    ];
    mainProgram = "xed";
  };
}
