{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, nix-update-script
, pkg-config
, meson
, ninja
, vala
, gtk3
, granite
, wingpanel
, libgee
, libxml2
}:

stdenv.mkDerivation rec {
  pname = "wingpanel-indicator-nightlight";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = pname;
    rev = version;
    sha256 = "1zxjw68byg4sjn8lzsidzmy4ipwxgnv8rm529a7wzlpgj2xq3x4j";
  };

  patches = [
    # Upstream code not respecting our localedir
    # https://github.com/elementary/wingpanel-indicator-nightlight/pull/91
    (fetchpatch {
      url = "https://github.com/elementary/wingpanel-indicator-nightlight/commit/4e15f71ed958df3569b2f1e224b9fb18613281f1.patch";
      sha256 = "07awmswyy0988pm6ggyz22mllja675cbdzrjdqc1xd4knwcgy77v";
    })
  ];

  nativeBuildInputs = [
    libxml2
    meson
    ninja
    pkg-config
    vala
  ];

  buildInputs = [
    granite
    gtk3
    libgee
    wingpanel
  ];

  passthru = {
    updateScript = nix-update-script {
      attrPath = "pantheon.${pname}";
    };
  };

  meta = with lib; {
    description = "Night Light Indicator for Wingpanel";
    homepage = "https://github.com/elementary/wingpanel-indicator-nightlight";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = teams.pantheon.members;
  };
}
