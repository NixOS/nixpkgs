{
  stdenv,
  lib,
  fetchFromGitHub,
  docbook_xsl,
  exempi,
  gdk-pixbuf,
  glib,
  gobject-introspection,
  gtk3,
  gtk-doc,
  itstool,
  lcms2,
  libexif,
  libjpeg,
  libpeas,
  librsvg,
  libxml2,
  meson,
  ninja,
  pkg-config,
  python3,
  wrapGAppsHook3,
  cinnamon-desktop,
  yelp-tools,
  xapp,
  xapp-symbolic-icons,
}:

stdenv.mkDerivation rec {
  pname = "xviewer";
  version = "3.4.13";

  src = fetchFromGitHub {
    owner = "linuxmint";
    repo = "xviewer";
    rev = version;
    hash = "sha256-g7ifQ+2FeZzpWfKgtFrWj0YDOB0++s6KGffHhvqGNQE=";
  };

  nativeBuildInputs = [
    docbook_xsl
    gobject-introspection
    gtk-doc
    itstool
    meson
    ninja
    pkg-config
    python3
    wrapGAppsHook3
    yelp-tools
  ];

  buildInputs = [
    cinnamon-desktop
    exempi
    gdk-pixbuf
    glib
    gtk3
    lcms2
    libexif
    libjpeg
    libpeas
    librsvg
    libxml2
    xapp
  ];

  postPatch = ''
    # Switch to girepository-2.0
    substituteInPlace src/main.c \
      --replace-fail "#include <girepository.h>" "#include <girepository/girepository.h>" \
      --replace-fail "g_irepository_get_option_group" "gi_repository_get_option_group"

    substituteInPlace src/xviewer-plugin-engine.c \
      --replace-fail "#include <girepository.h>" "#include <girepository/girepository.h>" \
      --replace-fail "g_irepository_get_default" "gi_repository_dup_default" \
      --replace-fail "g_irepository_require" "gi_repository_require"
  '';

  preFixup = ''
    gappsWrapperArgs+=(
      --prefix XDG_DATA_DIRS : "${lib.makeSearchPath "share" [ xapp-symbolic-icons ]}"
    )
  '';

  meta = with lib; {
    description = "Generic image viewer from Linux Mint";
    mainProgram = "xviewer";
    homepage = "https://github.com/linuxmint/xviewer";
    license = licenses.gpl2Only;
    platforms = platforms.linux;
    maintainers = with maintainers; [ tu-maurice ];
    teams = [ teams.cinnamon ];
  };
}
