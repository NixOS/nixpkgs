{ stdenv, fetchurl, fetchFromGitHub, pkgconfig, which, zlib, bzip2, libpng, gnumake
, glib /* passthru only */

  # FreeType supports sub-pixel rendering.  This is patented by
  # Microsoft, so it is disabled by default.  This option allows it to
  # be enabled.  See http://www.freetype.org/patents.html.
, useEncumberedCode ? true
, useInfinality ? true
}:

assert useInfinality -> useEncumberedCode;

let
  version = "2.6.5";

  infinality = fetchFromGitHub {
    owner = "archfan";
    repo = "infinality_bundle";
    rev = "5c0949a477bf43d2ac4e57b4fc39bcc3331002ee";
    sha256 = "17389aqm6rlxl4b5mv1fx4b22x2v2n60hfhixfxqxpd8ialsdi6l";
  };

in
with { inherit (stdenv.lib) optional optionals optionalString; };
stdenv.mkDerivation rec {
  name = "freetype-${version}";

  src = fetchurl {
    url = "mirror://savannah/freetype/${name}.tar.bz2";
    sha256 = "1w5c87s4rpx9af5b3mk5cjd1yny3c4dq5p9iv3ixb3vr00a6w2p2";
  };

  patches = [
    # Patch for validation of OpenType and GX/AAT tables.
    (fetchurl {
      name = "freetype-2.2.1-enable-valid.patch";
      url = "http://pkgs.fedoraproject.org/cgit/rpms/freetype.git/plain/freetype-2.2.1-enable-valid.patch?id=9a81147af83b1166a5f301e379f85927cc610990";
      sha256 = "0zkgqhws2s0j8ywksclf391iijhidb1a406zszd7xbdjn28kmj2l";
    })
  ] ++ optionals (!useInfinality && useEncumberedCode) [
    # Patch to enable subpixel rendering.
    # See https://www.freetype.org/freetype2/docs/reference/ft2-lcd_filtering.html.
    (fetchurl {
      name = "freetype-2.3.0-enable-spr.patch";
      url = http://pkgs.fedoraproject.org/cgit/rpms/freetype.git/plain/freetype-2.3.0-enable-spr.patch?id=9a81147af83b1166a5f301e379f85927cc610990;
      sha256 = "13ni9n5q3nla38wjmxd4f8cy29gp62kjx2l6y6nqhdyiqp8fz8nd";
    })
  ];

  prePatch = optionalString useInfinality ''
    patches="$patches $(ls ${infinality}/*_freetype2-iu/*-infinality-*.patch)"
  '';

  outputs = [ "out" "dev" ];

  propagatedBuildInputs = [ zlib bzip2 libpng ]; # needed when linking against freetype
  # dependence on harfbuzz is looser than the reverse dependence
  nativeBuildInputs = [ pkgconfig which ]
    # FreeType requires GNU Make, which is not part of stdenv on FreeBSD.
    ++ optional (!stdenv.isLinux) gnumake;

  configureFlags = [ "--disable-static" "--bindir=$(dev)/bin" ];

  # The asm for armel is written with the 'asm' keyword.
  CFLAGS = optionalString stdenv.isArm "-std=gnu99";

  enableParallelBuilding = true;

  doCheck = true;

  postInstall = glib.flattenInclude;

  crossAttrs = stdenv.lib.optionalAttrs (stdenv.cross.libc or null != "msvcrt") {
    # Somehow it calls the unwrapped gcc, "i686-pc-linux-gnu-gcc", instead
    # of gcc. I think it's due to the unwrapped gcc being in the PATH. I don't
    # know why it's on the PATH.
    configureFlags = "--disable-static CC_BUILD=gcc";
  };

  meta = with stdenv.lib; {
    description = "A font rendering engine";
    longDescription = ''
      FreeType is a portable and efficient library for rendering fonts. It
      supports TrueType, Type 1, CFF fonts, and WOFF, PCF, FNT, BDF and PFR
      fonts. It has a bytecode interpreter and has an automatic hinter called
      autofit which can be used instead of hinting instructions included in
      fonts.
    '';
    homepage = https://www.freetype.org/;
    license = licenses.gpl2Plus; # or the FreeType License (BSD + advertising clause)
    #ToDo: encumbered = useEncumberedCode;
    platforms = platforms.all;
  };
}
