{ lib, stdenvNoCC, fetchFromGitHub }:

stdenvNoCC.mkDerivation rec {
  pname = "bibata-cursors-translucent";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "Silicasandwhich";
    repo = "Bibata_Cursor_Translucent";
    rev = "v${version}";
    sha256 = "1ddnwqkxricnd731blckcxvksbgql8k4pfiz65591p81n5095k8y";
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
    maintainers = with maintainers; [ dtzWill AdsonCicilioti ];
  };
}
