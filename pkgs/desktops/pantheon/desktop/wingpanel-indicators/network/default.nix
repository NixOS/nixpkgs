{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, nix-update-script
, substituteAll
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
}:

stdenv.mkDerivation rec {
  pname = "wingpanel-indicator-network";
  version = "7.0.1";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = pname;
    rev = version;
    sha256 = "sha256-pz2sWN33d20/fMByR+XrNz2lxPdgCA6vxism3E/Fh/I=";
  };

  patches = [
    # PopoverWidget: fix flowbox child focus
    # https://github.com/elementary/wingpanel-indicator-network/pull/288
    (fetchpatch {
      url = "https://github.com/elementary/wingpanel-indicator-network/commit/88db9004249334e1316321e0373a3065900fe6f1.patch";
      sha256 = "sha256-rpAULo4qVPO3yr7cBVeKyT7L43zHVEdYLJD4x0ukBs4=";
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
    networkmanager
    libnma
    wingpanel
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "Network Indicator for Wingpanel";
    homepage = "https://github.com/elementary/wingpanel-indicator-network";
    license = licenses.lgpl21Plus;
    platforms = platforms.linux;
    maintainers = teams.pantheon.members;
  };
}
