{ stdenv
, fetchFromGitHub
, pantheon
, substituteAll
, meson
, ninja
, pkgconfig
, vala
, libgee
, elementary-dpms-helper
, elementary-settings-daemon
, granite
, gtk3
, glib
, dbus
, polkit
, switchboard
}:

stdenv.mkDerivation rec {
  pname = "switchboard-plug-power";
  version = "2.3.5";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = pname;
    rev = version;
    sha256 = "1wcxz4jxyv8kms9gxpwvrb356h10qvcwmdjzjzl2bvj5yl1rfcs9";
  };

  passthru = {
    updateScript = pantheon.updateScript {
      repoName = pname;
    };
  };

  nativeBuildInputs = [
    meson
    ninja
    pkgconfig
    vala
  ];

  buildInputs = [
    dbus
    glib
    granite
    gtk3
    libgee
    polkit
    switchboard
  ];

  patches = [
    (substituteAll {
      src = ./dpms-helper-exec.patch;
      elementary_dpms_helper = elementary-dpms-helper;
    })
    ./hardcode-gsettings.patch
  ];

  postPatch = ''
    substituteInPlace src/MainView.vala \
      --subst-var-by DPMS_HELPER_GSETTINGS_PATH ${glib.getSchemaPath elementary-dpms-helper}
    substituteInPlace src/MainView.vala \
      --subst-var-by GSD_GSETTINGS_PATH ${glib.getSchemaPath elementary-settings-daemon}
  '';

  PKG_CONFIG_SWITCHBOARD_2_0_PLUGSDIR = "${placeholder "out"}/lib/switchboard";
  PKG_CONFIG_DBUS_1_SYSTEM_BUS_SERVICES_DIR = "${placeholder "out"}/share/dbus-1/system-services";
  PKG_CONFIG_DBUS_1_SYSCONFDIR = "${placeholder "out"}/etc";
  PKG_CONFIG_POLKIT_GOBJECT_1_POLICYDIR = "${placeholder "out"}/share/polkit-1/actions";

  meta = with stdenv.lib; {
    description = "Switchboard Power Plug";
    homepage = https://github.com/elementary/switchboard-plug-power;
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = pantheon.maintainers;
  };
}
