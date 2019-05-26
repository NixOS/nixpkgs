{ stdenv, fetchFromGitHub, pantheon, meson, python3, ninja
, pkgconfig, vala, libgee, granite, gtk3, polkit, zeitgeist
, switchboard, lightlocker, pantheon-agent-geoclue2, gobject-introspection }:

stdenv.mkDerivation rec {
  pname = "switchboard-plug-security-privacy";
  version = "2.2.1";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = pname;
    rev = version;
    sha256 = "0k2bq7l0m7qfpy1mkb3qvsinqd8n4lp0vwz3x64wlgfn2qipm1fn";
  };

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
    python3
    vala
  ];

  buildInputs = [
    granite
    gtk3
    libgee
    polkit
    switchboard
    zeitgeist
  ];

  PKG_CONFIG_SWITCHBOARD_2_0_PLUGSDIR = "${placeholder ''out''}/lib/switchboard";

  patches = [
    ./hardcode-gsettings.patch
  ];

  postPatch = ''
    chmod +x meson/post_install.py
    patchShebangs meson/post_install.py

    substituteInPlace src/Views/LockPanel.vala --subst-var-by LIGHTLOCKER_GSETTINGS_PATH ${lightlocker}/share/gsettings-schemas/${lightlocker.name}/glib-2.0/schemas
    substituteInPlace src/Views/FirewallPanel.vala --subst-var-by SWITCHBOARD_SEC_PRIV_GSETTINGS_PATH $out/share/gsettings-schemas/${pname}-${version}/glib-2.0/schemas
  '';

  meta = with stdenv.lib; {
    description = "Switchboard Security & Privacy Plug";
    homepage = https://github.com/elementary/switchboard-plug-security-privacy;
    license = licenses.lgpl3Plus;
    platforms = platforms.linux;
    maintainers = pantheon.maintainers;
  };

}
