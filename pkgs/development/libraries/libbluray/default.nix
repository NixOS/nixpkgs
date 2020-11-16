{ stdenv, fetchurl, pkgconfig, fontconfig, autoreconfHook, DiskArbitration
, withJava ? false, jdk ? null, ant ? null
, withAACS ? false, libaacs ? null
, withBDplus ? false, libbdplus ? null
, withMetadata ? true, libxml2 ? null
, withFonts ? true, freetype ? null
}:

with stdenv.lib;

assert withJava -> jdk != null && ant != null;
assert withAACS -> libaacs != null;
assert withBDplus -> libbdplus != null;
assert withMetadata -> libxml2 != null;
assert withFonts -> freetype != null;

# Info on how to use:
# https://wiki.archlinux.org/index.php/BluRay

stdenv.mkDerivation rec {
  pname = "libbluray";
  version  = "1.2.1";

  src = fetchurl {
    url = "http://get.videolan.org/libbluray/${version}/${pname}-${version}.tar.bz2";
    sha256 = "1v1nmq631j0prih7pjl01ixhhwgrkjpxrjmmc342rsl8g4zyh8sj";
  };

  patches = optional withJava ./BDJ-JARFILE-path.patch;

  nativeBuildInputs = [ pkgconfig autoreconfHook ]
                      ++ optionals withJava [ ant ]
                      ;

  buildInputs = [ fontconfig ]
                ++ optional withJava jdk
                ++ optional withMetadata libxml2
                ++ optional withFonts freetype
                ++ optional stdenv.isDarwin DiskArbitration
                ;

  propagatedBuildInputs = optional withAACS libaacs;

  NIX_LDFLAGS = toString [
    (optionalString withAACS   "-L${libaacs}/lib -laacs")
    (optionalString withBDplus "-L${libbdplus}/lib -lbdplus")
  ];

  preConfigure = ''
    ${optionalString withJava ''export JDK_HOME="${jdk.home}"''}
  '';

  configureFlags =  with stdenv.lib;
                    optional (! withJava) "--disable-bdjava-jar"
                 ++ optional (! withMetadata) "--without-libxml2"
                 ++ optional (! withFonts) "--without-freetype"
                 ;

  meta = with stdenv.lib; {
    homepage = "http://www.videolan.org/developers/libbluray.html";
    description = "Library to access Blu-Ray disks for video playback";
    license = licenses.lgpl21;
    maintainers = with maintainers; [ abbradar ];
    platforms = platforms.unix;
  };
}
