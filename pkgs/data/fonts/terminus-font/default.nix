{ fetchurl, stdenv, perl, bdftopcf, mkfontdir, mkfontscale }:
stdenv.mkDerivation rec {
  name = "terminus-font-4.30";
  src = fetchurl {
#    urls = "http://www.is-vn.bg/hamster/${name}.tar.gz"
#    sha256 = "ca15718f715f1ca7af827a8ab5543b0c0339b2515f39f8c15f241b2bc1a15a9a";
     url = "http://ftp.de.debian.org/debian/pool/main/x/xfonts-terminus/xfonts-terminus_4.30.orig.tar.gz";
     sha256 = "d7f1253d75f0aa278b0bbf457d15927ed3bbf2565b9f6b829c2b2560fedc1712";
  };
  buildInputs = [ perl bdftopcf mkfontdir mkfontscale ];
  patchPhase = ''
    substituteInPlace Makefile --replace 'fc-cache' '#fc-cache'
  '';
  configurePhase = ''
    ./configure --prefix=$out
  '';
  buildPhase = ''
    make pcf
  '';
  installPhase = '' 
    make install-pcf
    make fontdir
  '';
  meta = {
    description = "A clean fixed width font";
    longDescription = ''
      Terminus Font is designed for long (8 and more hours per day) work
      with computers. Version 4.30 contains 850 characters, covers about
      120 language sets and supports ISO8859-1/2/5/7/9/13/15/16,
      Paratype-PT154/PT254, KOI8-R/U/E/F, Esperanto, many IBM, Windows and
      Macintosh code pages, as well as the IBM VGA, vt100 and xterm
      pseudographic characters.

      The sizes present are 6x12, 8x14, 8x16, 10x20, 11x22, 12x24, 14x28 and
      16x32. The styles are normal and bold (except for 6x12), plus
      EGA/VGA-bold for 8x14 and 8x16.
    '';
    homepage = http://www.is-vn.bg/hamster/;
    license = [ "GPLv2+" ];
    maintainers = with stdenv.lib.maintainers; [ astsmtl ];
    platforms = with stdenv.lib.platforms; linux;
  };
}
