{ stdenv, fetchurl, python3, bdftopcf, mkfontdir, mkfontscale }:

stdenv.mkDerivation rec {
  pname = "terminus-font";
  version = "4.48"; # set here for use in URL below

  src = fetchurl {
    url = "mirror://sourceforge/project/${pname}/${pname}-${version}/${pname}-${version}.tar.gz";
    sha256 = "1bwlkj39rqbyq57v5yssayav6hzv1n11b9ml2s0dpiyfsn6rqy9l";
  };

  nativeBuildInputs = [ python3 bdftopcf mkfontdir mkfontscale ];

  patchPhase = ''
    substituteInPlace Makefile --replace 'fc-cache' '#fc-cache'
  '';

  enableParallelBuilding = true;

  installTargets = [ "install" "fontdir" ];

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
    homepage = http://terminus-font.sourceforge.net/;
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ astsmtl ];
  };
}
