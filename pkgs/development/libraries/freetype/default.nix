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

  infinality_patch =
    let infinality_base_URL = "http://www.infinality.net/fedora/linux/zips";
        patch_file_name = "freetype-infinality-2.4.10-20120616_01-x86_64.tar.bz2";
    in fetchurl {
      url = "${infinality_base_URL}/${patch_file_name}";
      sha256 = "0n2z8iklb10in4hg4wdgyhir4nl94ry8zd94wvdyq8dbzm4v33nw";
    };

  patches = [ infinality_patch ];

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
