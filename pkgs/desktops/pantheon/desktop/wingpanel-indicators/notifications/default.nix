{ lib, stdenv
, fetchFromGitHub
, nix-update-script
, pantheon
, pkg-config
, meson
, ninja
, vala
, gtk3
, granite
, wingpanel
, libgee
, libhandy
, elementary-notifications
}:

stdenv.mkDerivation rec {
  pname = "wingpanel-indicator-notifications";
  version = "6.0.1";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = pname;
    rev = version;
    sha256 = "1qrbg8l3ifz09jx6v5j7hmgw0hmirj6mh3z634yl1cadz45p8fc9";
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
    elementary-notifications
    granite
    gtk3
    libgee
    libhandy
    wingpanel
  ];

  meta = with lib; {
    description = "Notifications Indicator for Wingpanel";
    homepage = "https://github.com/elementary/wingpanel-indicator-notifications";
    license = licenses.lgpl21Plus;
    platforms = platforms.linux;
    maintainers = teams.pantheon.members;
  };
}
