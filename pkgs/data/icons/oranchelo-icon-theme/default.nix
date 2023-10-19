{ lib, stdenvNoCC, fetchFromGitHub, gtk3, plasma5Packages, hicolor-icon-theme }:

stdenvNoCC.mkDerivation rec {
  pname = "oranchelo-icon-theme";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "OrancheloTeam";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-IDsZj/X9rFSdDpa3bL6IPEPCRe5GustPteDxSbfz+SA=";
  };

  nativeBuildInputs = [
    gtk3
  ];

  propagatedBuildInputs = [
    plasma5Packages.breeze-icons
    hicolor-icon-theme
  ];

  dontDropIconThemeCache = true;

  makeFlags = [
    "DESTDIR=$(out)"
    "PREFIX="
  ];

  postInstall = ''
    # space in icon name causes gtk-update-icon-cache to fail
    mv "$out/share/icons/Oranchelo/apps/scalable/ grsync.svg" "$out/share/icons/Oranchelo/apps/scalable/grsync.svg"

    for theme in $out/share/icons/*; do
      gtk-update-icon-cache "$theme"
    done
  '';

  meta = with lib; {
    description = "Oranchelo icon theme";
    homepage = "https://github.com/OrancheloTeam/oranchelo-icon-theme";
    license = licenses.gpl3Only;
    platforms = platforms.linux;
    maintainers = with maintainers; [ _414owen ];
  };
}
