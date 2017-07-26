{ stdenv, fetchFromGitHub, autoconf, automake, libtool, gettext, pkgconfig, glib, readline, makeWrapper }:

stdenv.mkDerivation rec {
  name = "neardal-0.7-post-git-20150930";

  src = fetchFromGitHub {
    owner = "connectivity";
    repo = "neardal";
    rev = "5b1c8b5c2c45c10f11cee12fbcb397f8953850d7";
    sha256 = "12qwg7qiw2wfpaxfg2fjkmj5lls0g33xp6w433g8bnkvwlq4s29g";
  };

  buildInputs = [ autoconf automake libtool pkgconfig glib readline makeWrapper ];

  preConfigure = ''
    substituteInPlace "ncl/Makefile.am" --replace "noinst_PROGRAMS" "bin_PROGRAMS"
    substituteInPlace "demo/Makefile.am" --replace "noinst_PROGRAMS" "bin_PROGRAMS"
    sh autogen.sh
  '';

  configureFlags = [ "--disable-dependency-tracking" "--disable-traces" ];

  meta = with stdenv.lib; {
    description = "C APIs to exchange datas with the NFC daemon 'Neard'";
    license = licenses.lgpl2;
    homepage = https://01.org/linux-nfc;
    maintainers = with maintainers; [ tstrobel ];
    platforms = platforms.linux;
  };
}
