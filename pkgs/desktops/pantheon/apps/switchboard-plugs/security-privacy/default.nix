{ stdenv
, fetchFromGitHub
, nix-update-script
, pantheon
, meson
, python3
, ninja
, pkgconfig
, vala
, libgee
, granite
, gtk3
, glib
, polkit
, zeitgeist
, switchboard
, lightlocker
}:

stdenv.mkDerivation rec {
  pname = "switchboard-plug-security-privacy";
  version = "2.2.4";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = pname;
    rev = version;
    sha256 = "0177lsly8qpqsfas3qc263as77h2k35avhw9708h1v8bllb3l2sb";
  };

  passthru = {
    updateScript = nix-update-script {
      attrPath = "pantheon.${pname}";
    };
  };

  nativeBuildInputs = [
    meson
    ninja
    pkgconfig
    python3
    vala
  ];

  buildInputs = [
    glib
    granite
    gtk3
    libgee
    polkit
    switchboard
    lightlocker
    zeitgeist
  ];

  postPatch = ''
    chmod +x meson/post_install.py
    patchShebangs meson/post_install.py
  '';

  meta = with stdenv.lib; {
    description = "Switchboard Security & Privacy Plug";
    homepage = "https://github.com/elementary/switchboard-plug-security-privacy";
    license = licenses.lgpl3Plus;
    platforms = platforms.linux;
    maintainers = pantheon.maintainers;
  };

}
