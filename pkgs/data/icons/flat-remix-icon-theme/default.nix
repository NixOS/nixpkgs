{ stdenv, fetchFromGitHub , gtk3 }:

stdenv.mkDerivation rec  {
  pname = "flat-remix-icon-theme";
  version = "20191122";

  src = fetchFromGitHub  {
    owner = "daniruiz";
    repo = "flat-remix";
    rev = version;
    sha256 = "1rv35r52l7xxjpajwli0md07k3xl7xplbw919vjmsb1hhrzavzzg";
  };

  nativeBuildInputs = [ gtk3 ];

  installPhase = ''
    mkdir -p $out/share/icons
    mv Flat-Remix* $out/share/icons/
  '';

  postFixup = ''
    for theme in $out/share/icons/*; do
      gtk-update-icon-cache $theme
    done
  '';

  meta = with stdenv.lib; {
    description = "Flat remix is a pretty simple icon theme inspired on material design";
    homepage = https://drasite.com/flat-remix;
    license = with licenses; [ gpl3 ];
    platforms = platforms.linux;
    maintainers = with maintainers; [ mschneider ];
  };
}
 
