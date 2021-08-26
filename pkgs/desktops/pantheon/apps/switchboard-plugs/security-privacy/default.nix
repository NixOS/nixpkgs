{ lib, stdenv
, fetchFromGitHub
, fetchpatch
, nix-update-script
, pantheon
, meson
, python3
, ninja
, pkg-config
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
    sha256 = "sha256-Sws6FqUL7QAROInDrcqYAp6j1TCC4aGV0/hi5Kmm5wQ=";
  };

  patches = [
    # Fix build with latest Vala.
    (fetchpatch {
      url = "https://github.com/elementary/switchboard-plug-security-privacy/commit/c8e422e630bbee0badcf4df26364c9e83e06bad0.patch";
      sha256 = "5Gm+muZiCraJC5JaGVVo0HDJ7KxjOpclHRW1RKsk3bc=";
    })
  ];

  passthru = {
    updateScript = nix-update-script {
      attrPath = "pantheon.${pname}";
    };
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
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

  meta = with lib; {
    description = "Switchboard Security & Privacy Plug";
    homepage = "https://github.com/elementary/switchboard-plug-security-privacy";
    license = licenses.lgpl3Plus;
    platforms = platforms.linux;
    maintainers = pantheon.maintainers;
  };

}
