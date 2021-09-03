{ lib, stdenv, fetchFromGitHub, gtk3, gnome-icon-theme, hicolor-icon-theme }:

stdenv.mkDerivation rec {
  pname = "numix-icon-theme";
  version = "21.04.14";

  src = fetchFromGitHub {
    owner = "numixproject";
    repo = pname;
    rev = version;
    sha256 = "1ilzqh9f7skdfg5sl97zfgwrzvwa1zna22dpq0954gyyzvy7k7lg";
  };

  nativeBuildInputs = [ gtk3 ];

  propagatedBuildInputs = [ gnome-icon-theme hicolor-icon-theme ];

  dontDropIconThemeCache = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/icons
    cp -a Numix{,-Light} $out/share/icons/

    for theme in $out/share/icons/*; do
      gtk-update-icon-cache $theme
    done

    runHook postInstall
  '';

  meta = with lib; {
    description = "Numix icon theme";
    homepage = "https://numixproject.github.io";
    license = licenses.gpl3Only;
    # darwin cannot deal with file names differing only in case
    platforms = platforms.linux;
    maintainers = with maintainers; [ romildo ];
  };
}
