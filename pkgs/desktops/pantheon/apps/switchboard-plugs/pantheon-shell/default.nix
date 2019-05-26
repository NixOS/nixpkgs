{ stdenv, fetchFromGitHub, pantheon, meson, ninja, pkgconfig, vala
, libgee, granite, gexiv2, elementary-settings-daemon, gtk3, gnome-desktop
, gala, wingpanel, plank, switchboard, gettext, gobject-introspection, bamf }:

stdenv.mkDerivation rec {
  pname = "switchboard-plug-pantheon-shell";
  version = "2.8.1";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = pname;
    rev = version;
    sha256 = "1vrnzxqzl84k8gbrais4j1jyap10kvil4cr769jpr3q3bkbblwrw";
  };

  passthru = {
    updateScript = pantheon.updateScript {
      repoName = pname;
    };
  };

  nativeBuildInputs = [
    gettext
    gobject-introspection
    meson
    ninja
    pkgconfig
    vala
  ];

  buildInputs = [
    bamf
    gexiv2
    gnome-desktop
    elementary-settings-daemon
    granite
    gtk3
    libgee
    plank
    switchboard
  ];

  patches = [
    ./backgrounds.patch # Having https://github.com/elementary/switchboard-plug-pantheon-shell/issues/166 would make this patch uneeded
    ./hardcode-gsettings.patch
  ];

  postPatch = ''
    substituteInPlace src/Views/Appearance.vala --subst-var-by GALA_GSETTINGS_PATH ${gala}/share/gsettings-schemas/${gala.name}/glib-2.0/schemas
    substituteInPlace src/Views/Appearance.vala --subst-var-by WINGPANEL_GSETTINGS_PATH ${wingpanel}/share/gsettings-schemas/${wingpanel.name}/glib-2.0/schemas
  '';


  PKG_CONFIG_SWITCHBOARD_2_0_PLUGSDIR = "${placeholder ''out''}/lib/switchboard";

  meta = with stdenv.lib; {
    description = "Switchboard Desktop Plug";
    homepage = https://github.com/elementary/switchboard-plug-pantheon-shell;
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = pantheon.maintainers;
  };
}
