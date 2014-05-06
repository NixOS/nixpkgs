{ stdenv, fetchurl, gnumake
  # FreeType supports sub-pixel rendering.  This is patented by
  # Microsoft, so it is disabled by default.  This option allows it to
  # be enabled.  See http://www.freetype.org/patents.html.
, useEncumberedCode ? false
}:

let

  version = "2.5.3";

in

stdenv.mkDerivation rec {
  name = "freetype-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/freetype/${name}.tar.bz2";
    sha256 = "0pppcn73b5pwd7zdi9yfx16f5i93y18q7q4jmlkwmwrfsllqp160";
  };

  configureFlags = "--disable-static";

  NIX_CFLAGS_COMPILE = with stdenv.lib;
    " -fno-strict-aliasing" # from Gentoo, see https://bugzilla.redhat.com/show_bug.cgi?id=506840
    + optionalString useEncumberedCode " -DFT_CONFIG_OPTION_SUBPIXEL_RENDERING=1";

  patches = [ ./enable-validation.patch ]; # from Gentoo

  # The asm for armel is written with the 'asm' keyword.
  CFLAGS = stdenv.lib.optionalString stdenv.isArm "-std=gnu99";

  # FreeType requires GNU Make, which is not part of stdenv on FreeBSD.
  buildInputs = stdenv.lib.optional (!stdenv.isLinux) gnumake;

  enableParallelBuilding = true;

  doCheck = true;

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
    license = if useEncumberedCode then "unfree"
      else "GPLv2+"; # or the FreeType License (BSD + advertising clause)
    platforms = stdenv.lib.platforms.all;
  };
}
