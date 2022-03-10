{ lib, stdenv, fetchFromGitHub, gtk3, numix-icon-theme, hicolor-icon-theme }:

stdenv.mkDerivation rec {
  pname = "numix-icon-theme-circle";
  version = "22.03.01";

  src = fetchFromGitHub {
    owner = "numixproject";
    repo = pname;
    rev = version;
    sha256 = "sha256-adSoFKvemirQtxoS6KrQvXxtIOKFZ73PTktVXytblbM=";
  };

  nativeBuildInputs = [ gtk3 ];

  propagatedBuildInputs = [ numix-icon-theme hicolor-icon-theme ];

  dontDropIconThemeCache = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/icons
    cp -a Numix-Circle{,-Light} $out/share/icons

    for panel in $out/share/icons/*/*/panel; do
      ln -sf $(realpath ${numix-icon-theme}/share/icons/Numix/16/$(readlink $panel)) $panel
    done

    for theme in $out/share/icons/*; do
      gtk-update-icon-cache $theme
    done

    runHook postInstall
  '';

  meta = with lib; {
    description = "Numix icon theme (circle version)";
    homepage = "https://numixproject.github.io";
    license = licenses.gpl3Only;
    # darwin cannot deal with file names differing only in case
    platforms = platforms.linux;
    maintainers = with maintainers; [ romildo ];
  };
}
