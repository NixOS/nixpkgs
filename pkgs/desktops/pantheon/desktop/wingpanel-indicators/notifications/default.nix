{ lib, stdenv
, fetchFromGitHub
, nix-update-script
, pantheon
, pkg-config
, fetchpatch
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
  version = "6.0.0";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = pname;
    rev = version;
    sha256 = "1pvcpk1d2zh9pvw0clv3bhf2plcww6nbxs6j7xjbvnaqs7d6i1k2";
  };

  patches = [
    # Upstream code not respecting our localedir
    # https://github.com/elementary/wingpanel-indicator-notifications/pull/218
    (fetchpatch {
      url = "https://github.com/elementary/wingpanel-indicator-notifications/commit/c7e73f0683561345935a959dafa2083b7e22fe99.patch";
      sha256 = "10xiyq42bqfmih1jgqpq64nha3n0y7ra3j7j0q27rn5hhhgbyjs7";
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
