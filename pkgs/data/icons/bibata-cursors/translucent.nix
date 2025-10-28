{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:

stdenvNoCC.mkDerivation rec {
  pname = "bibata-cursors-translucent";
  version = "1.1.2";

  src = fetchFromGitHub {
    owner = "Silicasandwhich";
    repo = "Bibata_Cursor_Translucent";
    rev = "v${version}";
    sha256 = "sha256-RroynJfdFpu+Wl9iw9NrAc9wNZsSxWI+heJXUTwEe7s=";
  };

  installPhase = ''
    install -dm 0755 $out/share/icons
    cp -pr Bibata_* $out/share/icons/
  '';

  meta = with lib; {
    description = "Translucent Varient of the Material Based Cursor";
    homepage = "https://github.com/Silicasandwhich/Bibata_Cursor_Translucent";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = [ ];
  };
}
