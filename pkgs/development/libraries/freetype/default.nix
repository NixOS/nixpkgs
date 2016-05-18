{ stdenv, fetchurl, fetchpatch, pkgconfig, which, zlib, bzip2, libpng, gnumake
, glib /* passthru only */

  # FreeType supports sub-pixel rendering.  This is patented by
  # Microsoft, so it is disabled by default.  This option allows it to
  # be enabled.  See http://www.freetype.org/patents.html.
, useEncumberedCode ? true
}:

let
  version = "2.6.2";

  # Don't use fetchpatch. It mangles them. That's an hour I'll never get back.
  fetchbohoomil = name: sha256: fetchurl {
    url = https://raw.githubusercontent.com/bohoomil/fontconfig-ultimate/254b688f96d4a37f78fb594303a43160fc15c7cd/freetype/ + name;
    inherit sha256;
  };
in
with { inherit (stdenv.lib) optional optionals optionalString; };
stdenv.mkDerivation rec {
  name = "freetype-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/freetype/${name}.tar.bz2";
    sha256 = "14mqrfgl18q2by1yzv6vcxi97zjy4kppcgsqf312mhfwgkpvvxms";
  };

  patches = []
    # mingw: these patches use `strcasestr` which isn't available on windows
    ++ optionals (useEncumberedCode && stdenv.cross.libc or null != "msvcrt" ) [
      (fetchbohoomil "01-freetype-2.6.2-enable-valid.patch"
        "1szq0zha7n41f4pq179wgfkam034mp2xn0xc36sdl5sjp9s9hv08")
      (fetchbohoomil "02-upstream-2015.12.05.patch"
        "0781r9n35kpn8db8nma0l47cpkzh0hbp84ziii5sald90dnrqdj4")
      (fetchbohoomil "03-infinality-2.6.2-2015.12.05.patch"
        "0wcjf9hiymplgqm3szla633i417pb57vpzzs2dyl1dnmcxgqa2y8")
    ];

  outputs = [ "dev" "out" ];

  propagatedBuildInputs = [ zlib bzip2 libpng ]; # needed when linking against freetype
  # dependence on harfbuzz is looser than the reverse dependence
  nativeBuildInputs = [ pkgconfig which ]
    # FreeType requires GNU Make, which is not part of stdenv on FreeBSD.
    ++ optional (!stdenv.isLinux) gnumake;

  configureFlags = "--disable-static --bindir=$(dev)/bin";

  # from Gentoo, see https://bugzilla.redhat.com/show_bug.cgi?id=506840
  NIX_CFLAGS_COMPILE = "-fno-strict-aliasing";
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
    homepage = http://www.freetype.org/;
    license = licenses.gpl2Plus; # or the FreeType License (BSD + advertising clause)
    #ToDo: encumbered = useEncumberedCode;
    platforms = platforms.all;
  };
}
