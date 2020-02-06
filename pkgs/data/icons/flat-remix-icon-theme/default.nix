{ stdenv, fetchFromGitHub , gtk3 }:

stdenv.mkDerivation rec  {
  pname = "flat-remix-icon-theme";
  version = "20191018";

  src = fetchFromGitHub  {
    owner = "daniruiz";
    repo = "flat-remix";
    rev = version;
    sha256 = "13ibxvrvri04lb5phm49b6d553jh0aigm57z5i0nsins405gixn9";
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
 
