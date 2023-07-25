{ lib
, stdenv
, fetchFromGitHub
, desktop-file-utils
, glib
, gtk3
, intltool
, meson
, ninja
, pkg-config
, vala
, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  pname = "budgie-desktop-view";
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "BuddiesOfBudgie";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-USsySJuDov2oe9UXyzACBAyYIRLKSXOMXdia8Ix/8TE=";
  };

  nativeBuildInputs = [
    desktop-file-utils
    intltool
    meson
    ninja
    pkg-config
    vala
    wrapGAppsHook
  ];

  buildInputs = [
    glib
    gtk3
  ];

  preInstall = ''
    substituteInPlace ../scripts/mesonPostInstall.sh --replace "update-desktop-database -q" "update-desktop-database $out/share/applications"
  '';

  meta = with lib; {
    description = "The official Budgie desktop icons application/implementation";
    homepage = "https://github.com/BuddiesOfBudgie/budgie-desktop-view";
    mainProgram = "org.buddiesofbudgie.budgie-desktop-view";
    platforms = platforms.linux;
    maintainers = [ maintainers.federicoschonborn ];
    license = licenses.asl20;
  };
}
