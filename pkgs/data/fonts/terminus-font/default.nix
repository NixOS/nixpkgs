{ stdenv, fetchurl, perl, bdftopcf, mkfontdir, mkfontscale }:

stdenv.mkDerivation rec {
  name = "terminus-font-4.40";

  src = fetchurl {
    url = "mirror://sourceforge/project/terminus-font/${name}/${name}.tar.gz";
    sha256 = "0487cyx5h1f0crbny5sg73a22gmym5vk1i7646gy7hgiscj2rxb4";
  };

  buildInputs = [ perl bdftopcf mkfontdir mkfontscale ];

  patchPhase = ''
    substituteInPlace Makefile --replace 'fc-cache' '#fc-cache'
  '';

  configurePhase = ''
    sh ./configure --prefix=$out
  '';

  installPhase = ''
    make install fontdir
  '';

  meta = with stdenv.lib; {
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
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ astsmtl ];
    platforms = platforms.linux;
  };
}
