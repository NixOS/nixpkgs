{ lib, stdenv, fetchurl, xfce }:

let
  category = "art";
in

stdenv.mkDerivation rec {
  pname  = "xfwm4-themes";
  version = "4.10.0";

  src = fetchurl {
    url = "mirror://xfce/src/${category}/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.bz2";
    sha256 = "sha256-MhTV8A6XA7XoyefDKH1gbe3scoXOtNXbMy6TraZv1XU=";
  };

  passthru.updateScript = xfce.archiveUpdater { inherit category pname version; };

  meta = with lib; {
    homepage = "https://www.xfce.org/";
    description = "Themes for Xfce";
    license = licenses.gpl3Only;
    platforms = platforms.linux;
    maintainers = with maintainers; [ volth ] ++ teams.xfce.members;
  };
}
