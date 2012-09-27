{ stdenv, fetchurl, gnumake
, # FreeType supports sub-pixel rendering.  This is patented by
  # Microsoft, so it is disabled by default.  This option allows it to
  # be enabled.  See http://www.freetype.org/patents.html.
  useEncumberedCode ? false
}:

stdenv.mkDerivation rec {
  name = "freetype-2.4.10";

  src = fetchurl {
    url = "mirror://sourceforge/freetype/${name}.tar.bz2";
    sha256 = "0bwrkqpygayfc1rf6rr1nb8l3svgn1fmjz8davg2hnf46cn293hc";
  };

  configureFlags = "--disable-static";

  NIX_CFLAGS_COMPILE = stdenv.lib.optionalString useEncumberedCode
    "-DFT_CONFIG_OPTION_SUBPIXEL_RENDERING=1";

  # The asm for armel is written with the 'asm' keyword.
  CFLAGS = stdenv.lib.optionalString stdenv.isArm "-std=gnu99";

  # FreeType requires GNU Make, which is not part of stdenv on FreeBSD.
  buildInputs = stdenv.lib.optional (stdenv.system == "i686-freebsd") gnumake;

  enableParallelBuilding = true;

  postInstall =
    ''
      ln -s freetype2/freetype $out/include/freetype
    '';

  meta = {
    description = "A font rendering engine";
    homepage = http://www.freetype.org/;
    license = "GPLv2+"; # or the FreeType License (BSD + advertising clause)
  };
}
