{ stdenv, fetchFromGitHub, gtk-engine-murrine }:

stdenv.mkDerivation rec {
  name = "mcos-mjv-dark-xfce-edition";
  version = "unstable-2018-12-13";

  src = fetchFromGitHub {
    owner = "paullinuxthemer";
    repo = "McOS-MJV-Dark-XFCE-Edition";
    rev = "f0ec35990d6235e756faa1afb82158f0967887d8";
    sha256 = "1gzdlvs2604j4apvrfsqvmqdy8r3wl9zkxkj5nzx6b6p957h4hkp";
  };

  propagatedUserEnvPkgs = [ gtk-engine-murrine ];

  installPhase = ''
    mkdir -p $out/share/themes
    mv McOS-MJV-Dark-XFCE-Edition-2.2 mcos-mjv-dark-xfce-edition
    cp -r 'mcos-mjv-dark-xfce-edition' $out/share/themes
  '';

  meta = with stdenv.lib; {
    description = "Mac OS-themes(Dark) for the XFCE desktop";
    homepage = https://github.com/paullinuxthemer/McOS-MJV-Dark-XFCE-Edition;
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = [ maintainers.linarcx ];
  };
}
