{ stdenv, fetchurl, gnumake
, # FreeType supports sub-pixel rendering.  This is patented by
  # Microsoft, so it is disabled by default.  This option allows it to
  # be enabled.  See http://www.freetype.org/patents.html.
  useEncumberedCode ? false
}:

stdenv.mkDerivation (rec {
  name = "freetype-2.4.4";
  
  src = fetchurl {
    url = "mirror://sourceforge/freetype/${name}.tar.bz2";
    sha256 = "1vqg93473j6jma1bxms7mczk32j8is0g9inkcmmmqdsdvk3q30jb";
  };

  configureFlags = "--disable-static";

  NIX_CFLAGS_COMPILE = stdenv.lib.optionalString useEncumberedCode
    "-DFT_CONFIG_OPTION_SUBPIXEL_RENDERING=1";

  # The asm for armel is written with the 'asm' keyword.
  CFLAGS = stdenv.lib.optionalString stdenv.isArm "-std=gnu99";

  meta = {
    description = "A font rendering engine";
    homepage = http://www.freetype.org/;
    license = "GPLv2+"; # or the FreeType License (BSD + advertising clause)
  };
}

//

# FreeType requires GNU Make, which is not part of stdenv on FreeBSD.
(if stdenv.system == "i686-freebsd"
 then { buildInputs = [ gnumake ]; }
 else {}))
