{ lib
, stdenv
, fetchFromGitHub
, nix-update-script
, fetchpatch
, pkg-config
, meson
, ninja
, vala
, gtk3
, granite
, wingpanel
, accountsservice
, libgee
, libhandy
}:

stdenv.mkDerivation rec {
  pname = "wingpanel-indicator-session";
  version = "2.3.0";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = pname;
    rev = version;
    sha256 = "0hww856qjl4kjmmksd5gp8bc5vj4fhs2s9fmbnpbf88lg5ds0wv0";
  };

  patches = [
    # Upstream code not respecting our localedir
    # https://github.com/elementary/wingpanel-indicator-session/pull/162
    (fetchpatch {
      url = "https://github.com/elementary/wingpanel-indicator-session/commit/e85032da8e923df4589dc75ccded10026b6c1cd7.patch";
      sha256 = "139b2zbc6qjaw41nwfjkqv4npahkzryv4p5m6v10273clv6l72ng";
    })
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    vala
  ];

  buildInputs = [
    accountsservice
    granite
    gtk3
    libgee
    libhandy
    wingpanel
  ];

  passthru = {
    updateScript = nix-update-script {
      attrPath = "pantheon.${pname}";
    };
  };

  meta = with lib; {
    description = "Session Indicator for Wingpanel";
    homepage = "https://github.com/elementary/wingpanel-indicator-session";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = teams.pantheon.members;
  };
}
