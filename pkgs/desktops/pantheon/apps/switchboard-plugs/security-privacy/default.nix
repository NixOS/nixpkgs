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
, gala
, gtk3
, glib
, polkit
, zeitgeist
, switchboard
}:

stdenv.mkDerivation rec {
  pname = "switchboard-plug-security-privacy";
  version = "2.2.5";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = pname;
    rev = version;
    sha256 = "1ydr1xpbyxjcnd36c9j7a64srbz6gpbshwhcqj6591kmiqhmvknk";
  };

  patches = [
    # Upstream code not respecting our localedir
    # https://github.com/elementary/switchboard-plug-security-privacy/pull/130
    (fetchpatch {
      url = "https://github.com/elementary/switchboard-plug-security-privacy/commit/18fe438baba651670d7f0534856c3b2433e3d75d.patch";
      sha256 = "19qwm725k6h41kgg4a98i4rxx45s4bb1wxx0fzkh75gz9syfi58w";
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
    gala
    glib
    granite
    gtk3
    libgee
    polkit
    switchboard
    zeitgeist
  ];

  postPatch = ''
    chmod +x meson/post_install.py
    patchShebangs meson/post_install.py
  '';

  meta = with lib; {
    description = "Switchboard Security & Privacy Plug";
    homepage = "https://github.com/elementary/switchboard-plug-security-privacy";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = teams.pantheon.members;
  };

}
