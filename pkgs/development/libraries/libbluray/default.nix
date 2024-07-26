{ lib, stdenv, fetchurl, pkg-config, fontconfig, autoreconfHook, DiskArbitration
, withJava ? false, jdk17, ant, stripJavaArchivesHook
, withAACS ? false, libaacs
, withBDplus ? false, libbdplus
, withMetadata ? true, libxml2
, withFonts ? true, freetype
}:

# Info on how to use:
# https://wiki.archlinux.org/index.php/BluRay

stdenv.mkDerivation rec {
  pname = "libbluray";
  version = "1.3.4";

  src = fetchurl {
    url = "https://get.videolan.org/libbluray/${version}/${pname}-${version}.tar.bz2";
    hash = "sha256-R4/9aKD13ejvbKmJt/A1taCiLFmRQuXNP/ewO76+Xys=";
  };

  nativeBuildInputs = [ pkg-config autoreconfHook ]
    ++ lib.optionals withJava [ jdk17 ant stripJavaArchivesHook ];

  buildInputs = [ fontconfig ]
    ++ lib.optional withMetadata libxml2
    ++ lib.optional withFonts freetype
    ++ lib.optional stdenv.isDarwin DiskArbitration;

  propagatedBuildInputs = lib.optional withAACS libaacs;

  env.NIX_LDFLAGS = lib.optionalString withAACS "-L${libaacs}/lib -laacs"
    + lib.optionalString withBDplus " -L${libbdplus}/lib -lbdplus";

  configureFlags = lib.optional (!withJava) "--disable-bdjava-jar"
    ++ lib.optional (!withMetadata) "--without-libxml2"
    ++ lib.optional (!withFonts) "--without-freetype";

  meta = with lib; {
    homepage = "http://www.videolan.org/developers/libbluray.html";
    description = "Library to access Blu-Ray disks for video playback";
    license = licenses.lgpl21;
    maintainers = with maintainers; [ abbradar ];
    platforms = platforms.unix;
  };
}
