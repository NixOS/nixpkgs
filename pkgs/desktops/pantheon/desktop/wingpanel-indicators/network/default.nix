{ lib, stdenv
, fetchFromGitHub
, fetchpatch
, nix-update-script
, substituteAll
, pantheon
, pkg-config
, meson
, ninja
, vala
, gtk3
, granite
, networkmanager
, libnma
, wingpanel
, libgee
, elementary-capnet-assist
}:

stdenv.mkDerivation rec {
  pname = "wingpanel-indicator-network";
  version = "2.3.0";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = pname;
    rev = version;
    sha256 = "0q5ad2sj0nmigrh1rykb2kvik3hzibzyafdvkkmjd6y92145lwl1";
  };

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
    granite
    gtk3
    libgee
    networkmanager
    libnma
    wingpanel
  ];

  patches = [
    (substituteAll {
      src = ./fix-paths.patch;
      elementary_capnet_assist = elementary-capnet-assist;
    })
    # Upstream code not respecting our localedir
    # https://github.com/elementary/wingpanel-indicator-network/pull/228
    (fetchpatch {
      url = "https://github.com/elementary/wingpanel-indicator-network/commit/eacc7d46a94a980005e87e38e6c943143a09692a.patch";
      sha256 = "1svg07fqmplchp1ass0h8qkr3g24pkw8dcsnd54ddmvnjzwrzz0a";
    })
  ];

  meta = with lib; {
    description = "Network Indicator for Wingpanel";
    homepage = "https://github.com/elementary/wingpanel-indicator-network";
    license = licenses.lgpl21Plus;
    platforms = platforms.linux;
    maintainers = teams.pantheon.members;
  };
}
