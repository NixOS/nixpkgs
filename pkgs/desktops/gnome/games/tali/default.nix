{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  gtk3,
  gnome,
  gdk-pixbuf,
  librsvg,
  libgnome-games-support,
  gettext,
  itstool,
  libxml2,
  wrapGAppsHook3,
  meson,
  ninja,
  python3,
  desktop-file-utils,
}:

stdenv.mkDerivation rec {
  pname = "tali";
  version = "40.9";

  src = fetchurl {
    url = "mirror://gnome/sources/tali/${lib.versions.major version}/${pname}-${version}.tar.xz";
    sha256 = "+p7eNm8KcuTKpSGJw6sLEMG1aoDHiFsBZgJVjETc59M=";
  };

  nativeBuildInputs = [
    meson
    ninja
    python3
    desktop-file-utils
    pkg-config
    gnome.adwaita-icon-theme
    libxml2
    itstool
    gettext
    wrapGAppsHook3
  ];

  buildInputs = [
    gtk3
    gdk-pixbuf
    librsvg
    libgnome-games-support
  ];

  postPatch = ''
    chmod +x build-aux/meson_post_install.py
    patchShebangs build-aux/meson_post_install.py
  '';

  passthru = {
    updateScript = gnome.updateScript {
      packageName = pname;
      attrPath = "gnome.${pname}";
    };
  };

  meta = with lib; {
    homepage = "https://gitlab.gnome.org/GNOME/tali";
    description = "Sort of poker with dice and less money";
    mainProgram = "tali";
    maintainers = teams.gnome.members;
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
  };
}
