{ lib
, stdenv
, fetchFromGitHub
, nix-update-script
, fetchpatch
, meson
, ninja
, pkg-config
, vala
, libgee
, granite
, gtk3
, switchboard
}:

stdenv.mkDerivation rec {
  pname = "switchboard-plug-sharing";
  version = "2.1.5";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = pname;
    rev = version;
    sha256 = "00lqrxq1wz3y2s9jiz8rh9d571va2vza2gdwj6c86z3q4c4hmn17";
  };

  patches = [
    # Upstream code not respecting our localedir
    # https://github.com/elementary/switchboard-plug-sharing/pull/55
    (fetchpatch {
      url = "https://github.com/elementary/switchboard-plug-sharing/commit/5219839738b79e3c5f039a811d96a40eb2644eab.patch";
      sha256 = "020w746q7gzmic0pdnbxs792sx15wlsqaf2x770r5xwbyfmqr7bs";
    })
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    vala
  ];

  buildInputs = [
    granite
    gtk3
    libgee
    switchboard
  ];

  passthru = {
    updateScript = nix-update-script {
      attrPath = "pantheon.${pname}";
    };
  };

  meta = with lib; {
    description = "Switchboard Sharing Plug";
    homepage = "https://github.com/elementary/switchboard-plug-sharing";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = teams.pantheon.members;
  };
}
