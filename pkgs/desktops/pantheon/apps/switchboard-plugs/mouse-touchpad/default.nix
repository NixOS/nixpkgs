{ stdenv
, fetchFromGitHub
, pantheon
, meson
, ninja
, pkgconfig
, vala
, libgee
, granite
, gtk3
, switchboard
, elementary-settings-daemon
, glib
}:

stdenv.mkDerivation rec {
  pname = "switchboard-plug-mouse-touchpad";
  version = "2.3.0";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = pname;
    rev = version;
    sha256 = "1cg69nbdf4mcr16mi71aw9j8877lyj8yxjfk9bd3sml8f4fh7mmr";
  };

  patches = [
    ./hardcode-settings-daemon-gsettings.patch
  ];

  postPatch = ''
    substituteInPlace src/Views/Clicking.vala \
      --subst-var-by GSD_GSETTINGS ${glib.getSchemaPath elementary-settings-daemon}
  '';

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
    glib
    granite
    gtk3
    libgee
    switchboard
  ];

  meta = with stdenv.lib; {
    description = "Switchboard Mouse & Touchpad Plug";
    homepage = https://github.com/elementary/switchboard-plug-mouse-touchpad;
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = pantheon.maintainers;
  };
}
