{ stdenv, fetchurl, gnumake
  # FreeType supports sub-pixel rendering.  This is patented by
  # Microsoft, so it is disabled by default.  This option allows it to
  # be enabled.  See http://www.freetype.org/patents.html.
, useEncumberedCode ? false
, useInfinality ? true
}:

assert !(useEncumberedCode && useInfinality); # probably wouldn't make sense

let
  version = "2.4.11";
  infinality = rec {
    inherit useInfinality;
    vers = "20130104";
    subvers = "04";
    sha256 = "0dqglig34lfcw0w6sm6vmich0pcvq303vyh8jzqapvxgvrpr2156";

    base_URL = "http://www.infinality.net/fedora/linux/zips";
    url = "${base_URL}/freetype-infinality-${version}-${vers}_${subvers}-x86_64.tar.bz2";
  };

in
stdenv.mkDerivation rec {
  name = "freetype-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/freetype/${name}.tar.bz2";
    sha256 = "0gxyzxqpyf8g85y6g1zc1wqrh71prbbk8xfw4m8rwzb4ck5hp7gg";
  };

  infinality_patch = if useInfinality
    then fetchurl { inherit (infinality) url sha256; }
    else null;

  configureFlags = "--disable-static";

  NIX_CFLAGS_COMPILE = with stdenv.lib;
    " -fno-strict-aliasing" # from Gentoo, see https://bugzilla.redhat.com/show_bug.cgi?id=506840
    + optionalString useEncumberedCode " -DFT_CONFIG_OPTION_SUBPIXEL_RENDERING=1"
    + optionalString useInfinality " -DTT_CONFIG_OPTION_SUBPIXEL_HINTING=1"
    ;

  patches = [ ./enable-validation.patch ] # from Gentoo
    ++ stdenv.lib.optional useInfinality [ infinality_patch ];

  # The asm for armel is written with the 'asm' keyword.
  CFLAGS = stdenv.lib.optionalString stdenv.isArm "-std=gnu99";

  # FreeType requires GNU Make, which is not part of stdenv on FreeBSD.
  buildInputs = stdenv.lib.optional (stdenv.system == "i686-freebsd") gnumake;

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

  passthru = { inherit infinality; }; # for fontconfig

  meta = {
    description = "A font rendering engine";
    homepage = http://www.freetype.org/;
    license = if useEncumberedCode then "unfree"
      else "GPLv2+"; # or the FreeType License (BSD + advertising clause)
  };
}
