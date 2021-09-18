{ lib, stdenv
, fetchFromGitHub
, fetchpatch
, nix-update-script
, pantheon
, meson
, ninja
, pkg-config
, vala
, libgee
, granite
, gtk3
, switchboard
, flatpak
}:

stdenv.mkDerivation rec {
  pname = "switchboard-plug-applications";
  version = "6.0.0";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = pname;
    rev = version;
    sha256 = "0hgvmrgg6g2sjb3sda7kzfcd3zgngd5w982drl6ll44k1mh16gsj";
  };

  patches = [
    # Upstream code not respecting our localedir
    # https://github.com/elementary/switchboard-plug-applications/pull/163
    (fetchpatch {
      url = "https://github.com/elementary/switchboard-plug-applications/commit/25db490654ab41694be7b7ba19218376f42fbb8d.patch";
      sha256 = "16y8zcwnnjsh72ifpyqcdb9f5ajdj0iy8kb5sj6v77c1cxdhrv29";
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
    vala
  ];

  buildInputs = [
    flatpak
    granite
    gtk3
    libgee
    switchboard
  ];

  meta = with lib; {
    description = "Switchboard Applications Plug";
    homepage = "https://github.com/elementary/switchboard-plug-applications";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = teams.pantheon.members;
  };
}
