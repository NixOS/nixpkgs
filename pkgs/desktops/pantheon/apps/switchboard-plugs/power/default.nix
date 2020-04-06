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
  version = "2.4.1";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = pname;
    rev = version;
    sha256 = "0hmchx0sfdm2c2f9khjvlaqcxmvzarn2vmwcdb3h5ifbj32vydzw";
  };

  passthru = {
    updateScript = pantheon.updateScript {
      attrPath = "pantheon.${pname}";
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
    elementary-dpms-helper
    elementary-settings-daemon
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
  ];

  meta = with stdenv.lib; {
    description = "Switchboard Power Plug";
    homepage = https://github.com/elementary/switchboard-plug-power;
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = pantheon.maintainers;
  };
}
