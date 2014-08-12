{ stdenv, fetchurl, fetchpatch, pkgconfig, which, zlib, bzip2, libpng, gnumake
  # FreeType supports sub-pixel rendering.  This is patented by
  # Microsoft, so it is disabled by default.  This option allows it to
  # be enabled.  See http://www.freetype.org/patents.html.
, glib/*passthru only*/
, useEncumberedCode ? true
}:

let
  version = "2.5.3";

  fetch_bohoomil = name: sha256: fetchpatch {
    url = https://raw.githubusercontent.com/bohoomil/fontconfig-ultimate/8a155db28f264520596cc3e76eb44824bdb30f8e/01_freetype2-iu/ + name;
    inherit sha256;
  };
in
with { inherit (stdenv.lib) optional optionalString; };
stdenv.mkDerivation rec {
  name = "freetype-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/freetype/${name}.tar.bz2";
    sha256 = "0pppcn73b5pwd7zdi9yfx16f5i93y18q7q4jmlkwmwrfsllqp160";
  };

  patches = [ ./enable-validation.patch ] # from Gentoo
    ++ [
      (fetch_bohoomil "freetype-2.5.3-pkgconfig.patch" "1dpfdh8kmka3gzv14glz7l79i545zizah6wma937574v5z2iy3nn")
      (fetch_bohoomil "fix_segfault_with_harfbuzz.diff" "1nx36inqrw717b86cla2miprdb3hii4vndw95k0jbbhfmax9k6fy")
    ]
    ++ optional useEncumberedCode
      (fetch_bohoomil "infinality-2.5.3.patch" "0mxiybcb4wwbicrjiinh1b95rv543bh05sdqk1v0ipr3fxfrb47q")
    ;

  propagatedBuildInputs = [ zlib bzip2 libpng ]; # needed when linking against freetype
  # dependence on harfbuzz is looser than the reverse dependence
  buildInputs = [ pkgconfig which ]
    # FreeType requires GNU Make, which is not part of stdenv on FreeBSD.
    ++ optional (!stdenv.isLinux) gnumake;

  # from Gentoo, see https://bugzilla.redhat.com/show_bug.cgi?id=506840
  NIX_CFLAGS_COMPILE = "-fno-strict-aliasing";
  # The asm for armel is written with the 'asm' keyword.
  CFLAGS = optionalString stdenv.isArm "-std=gnu99";

  enableParallelBuilding = true;

  doCheck = true;

  # compat hacks
  postInstall = glib.flattenInclude + ''
    ln -s . "$out"/include/freetype
  '';

  crossAttrs = {
    # Somehow it calls the unwrapped gcc, "i686-pc-linux-gnu-gcc", instead
    # of gcc. I think it's due to the unwrapped gcc being in the PATH. I don't
    # know why it's on the PATH.
    configureFlags = "--disable-static CC_BUILD=gcc";
  };

  meta = with stdenv.lib; {
    description = "A font rendering engine";
    homepage = http://www.freetype.org/;
    license = licenses.gpl2Plus; # or the FreeType License (BSD + advertising clause)
    #ToDo: encumbered = useEncumberedCode;
    platforms = platforms.all;
  };
}
