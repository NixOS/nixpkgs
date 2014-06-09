{ stdenv, fetchurl }:

stdenv.mkDerivation {
  name = "lohit-fonts-20140220";
  src = fetchurl {
    url = https://fedorahosted.org/releases/l/o/lohit/lohit-ttf-20140220.tar.gz;
    sha256 = "1rmgr445hw1n851ywy28csfvswz1i6hnc8mzp88qw2xk9j4dn32d";
  };

  installPhase = ''
    mkdir -p $out/share/fonts/truetype
    cp *.ttf $out/share/fonts/truetype
  '';

  meta = with stdenv.lib; {
    homepage = https://fedorahosted.org/lohit/;
    description = "Fonts for 21 Indian languages";
    license = licenses.ofl;
    maintainers = [ maintainers.ttuegel ];
    platforms = platforms.all;
  };
}
