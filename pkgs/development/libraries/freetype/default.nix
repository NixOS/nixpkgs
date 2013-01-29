{ stdenv, fetchurl, gnumake
, # FreeType supports sub-pixel rendering.  This is patented by
  # Microsoft, so it is disabled by default.  This option allows it to
  # be enabled.  See http://www.freetype.org/patents.html.
  useEncumberedCode ? false
}:

stdenv.mkDerivation rec {
  name = "freetype-2.4.11";

  src = fetchurl {
    url = "mirror://sourceforge/freetype/${name}.tar.bz2";
    sha256 = "0gxyzxqpyf8g85y6g1zc1wqrh71prbbk8xfw4m8rwzb4ck5hp7gg";
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

  crossAttrs = {
    # Somehow it calls the unwrapped gcc, "i686-pc-linux-gnu-gcc", instead
    # of gcc. I think it's due to the unwrapped gcc being in the PATH. I don't
    # know why it's on the PATH.
    configureFlags = "--disable-static CC_BUILD=gcc";
  };

  meta = {
    description = "A font rendering engine";
    homepage = http://www.freetype.org/;
    license = "GPLv2+"; # or the FreeType License (BSD + advertising clause)
  };
}
