{ stdenv, lib, fetchurl, variants ? [ "Blue" "Green" ] }:

with lib;

stdenv.mkDerivation rec {
  name = "${package-name}-${version}";
  package-name = "polar-xcursor-theme";
  version = "1.4";

  src = fetchurl {
    url = "https://dl.opendesktop.org/api/files/download/id/1460735356/27913-PolarCursorThemes.tar.bz2";
    sha256 = "15lmfgpzq9zfsd6q80zp3ylqdxsqmdrl5ykvwlw11qhxzl34viz4";
  };

  installPhase = ''
    for theme in ${concatStringsSep " " variants}; do
      mkdir -p $out/share/icons/$theme
      cp -R PolarCursorTheme-$theme/{cursors,index.theme} $out/share/icons/PolarCursorTheme-$theme/
      pushd $out/share/icons/PolarCursorTheme-$theme/cursors
      # Extracted from one of the comments on this theme.
      ln -s xterm ibeam
      ln -s question_arrow whats_this
      ln -s watch wait
      ln -s fleur size_all
      ln -s bottom_right_corner size_fdiag
      ln -s bottom_left_corner size_bdiag
      ln -s right_side size_hor
      ln -s top_side size_ver
      ln -s hand pointer
      ln -s hand pointing_hand
      ln -s dnd-none forbidden
      ln -s HandGrab openhand
      ln -s HandSqueezed closedhand
      popd
    done
  '';

  meta = {
    description = "Polar X cursor theme";
    homepage = http://www.kde-look.org/content/show.php?content=27913;
    platforms = platforms.all;
    license = licenses.gpl3;
    maintainers = with maintainers; [ msteen ];
  };
}
