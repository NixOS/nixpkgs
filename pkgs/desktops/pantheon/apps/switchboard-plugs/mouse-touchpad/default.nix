{ stdenv, fetchFromGitHub, pantheon, fetchpatch, meson, ninja, pkgconfig, vala
, libgee, granite, gtk3, switchboard, elementary-settings-daemon, gobject-introspection }:

stdenv.mkDerivation rec {
  pname = "switchboard-plug-mouse-touchpad";
  version = "2.2.0";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = pname;
    rev = version;
    sha256 = "0mr25p7j5hl8zmvz5i3g30s4xbdhk6d22lw2akch3si40il9q5fv";
  };

  patches = [
    ./hardcode-settings-daemon-gsettings.patch
  ];

  postPatch = ''
    substituteInPlace src/Views/General.vala --subst-var-by GSD_GSETTINGS ${elementary-settings-daemon}/share/gsettings-schemas/${elementary-settings-daemon.name}/glib-2.0/schemas
  '';

  passthru = {
    updateScript = pantheon.updateScript {
      repoName = pname;
    };
  };

  nativeBuildInputs = [
    gobject-introspection
    meson
    ninja
    pkgconfig
    vala
  ];

  buildInputs = [
    granite
    gtk3
    libgee
    switchboard
  ];

  PKG_CONFIG_SWITCHBOARD_2_0_PLUGSDIR = "${placeholder ''out''}/lib/switchboard";

  meta = with stdenv.lib; {
    description = "Switchboard Mouse & Touchpad Plug";
    homepage = https://github.com/elementary/switchboard-plug-mouse-touchpad;
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = pantheon.maintainers;
  };
}
