{ stdenv, fetchFromGitHub, gtk-engine-murrine }:

stdenv.mkDerivation rec {
  name = "mcos-xfce-edition";

  src = fetchFromGitHub {
    owner = "paullinuxthemer";
    repo = "McOS-XFCE-Edition";
    rev = "8d90e108377e89359e69d83c83099195b6c98f10";
    sha256 = "0vvag2gakcsd60ypgkz86s7alhddwk2axgq85v7n4hrda21nhswy";
  };

  propagatedUserEnvPkgs = [ gtk-engine-murrine ];

  installPhase = ''
    mkdir -p $out/share/themes
    cp -r 'McOS-XFCE-Edition-II' $out/share/themes
    cp -r 'McOS-XFCE-Edition' $out/share/themes
  '';

  meta = with stdenv.lib; {
    description = "Mac OS-themes for the XFCE desktop";
    homepage = https://github.com/paullinuxthemer/McOS-XFCE-Edition;
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = [ maintainers.linarcx ];
  };
}
