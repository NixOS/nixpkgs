{ lib, stdenv, fetchzip }:

stdenv.mkDerivation rec {
  pname = "adwaita-dark-amoled-theme";
  version = "2022-07-11";
  revision = "52d3774f0bb91c8802ce4ab04e23ef0480d4da8c";

  src = fetchzip {
    url = "https://gitlab.com/tearch-linux/artworks/themes-and-icons/adwaita-dark-amoled/-/archive/${revision}/adwaita-dark-amoled-${revision}.zip";
    sha256 = "BfJc0LXDClYSAR1gvXRPDM+orP/fbpiy7BG94+dlcoo=";
  };

  dontbuild = true;

  installPhase = ''
    mkdir -p $out/share/themes/Adwaita-dark-amoled
    cp -r . $out/share/themes/Adwaita-dark-amoled
  '';

  preferLocalBuild = true;

  meta = with lib; {
    description = "A full black GTK3 theme, based on Adwaita";
    homepage = "https://gitlab.com/tearch-linux/artworks/themes-and-icons/adwaita-dark-amoled";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ quantenzitrone ];
  };
}
