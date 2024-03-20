{ lib
, stdenv
, fetchFromGitHub
, accountsservice
, budgie
, gtk3
, intltool
, libgee
, libpeas
, meson
, ninja
, pkg-config
, sassc
, vala
}:

stdenv.mkDerivation rec {
  pname = "budgie-user-indicator-redux";
  version = "1.0.2";

  src = fetchFromGitHub {
    owner = "EbonJaeger";
    repo = "budgie-user-indicator-redux";
    rev = "v${version}";
    hash = "sha256-X9b4H4PnrYGb/T7Sg9iXQeNDLoO1l0VCdbOCGUAgwC4=";
  };

  nativeBuildInputs = [
    intltool
    meson
    ninja
    pkg-config
    vala
  ];

  buildInputs = [
    accountsservice
    budgie.budgie-desktop
    gtk3
    libgee
    libpeas
    sassc
  ];

  meta = with lib; {
    description = "Manage your user session from the Budgie panel";
    homepage = "https://github.com/EbonJaeger/budgie-user-indicator-redux";
    changelog = "https://github.com/EbonJaeger/budgie-user-indicator-redux/blob/${src.rev}/CHANGELOG.md";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = teams.budgie.members;
  };
}
