{ stdenv, fetchurl, pkgconfig, fontconfig, autoreconfHook
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
  baseName = "libbluray";
  version  = "0.9.2";
  name = "${baseName}-${version}";

  src = fetchurl {
    url = "http://get.videolan.org/${baseName}/${version}/${name}.tar.bz2";
    sha256 = "1sp71j4agcsg17g6b85cqz78pn5vknl5pl39rvr6mkib5ps99jgg";
  };

  nativeBuildInputs = [ pkgconfig autoreconfHook ]
                      ++ optionals withJava [ ant ]
                      ;

  buildInputs = [ fontconfig ]
                ++ optional withJava jdk
                ++ optional withMetadata libxml2
                ++ optional withFonts freetype
                ;

  propagatedBuildInputs = stdenv.lib.optional withAACS libaacs;

  preConfigure = ''
    ${optionalString withJava ''export JDK_HOME="${jdk.home}"''}
    ${optionalString withAACS ''export NIX_LDFLAGS="$NIX_LDFLAGS -L${libaacs}/lib -laacs"''}
    ${optionalString withBDplus ''export NIX_LDFLAGS="$NIX_LDFLAGS -L${libbdplus}/lib -lbdplus"''}
  '';

  configureFlags =  with stdenv.lib;
                    optional (! withJava) "--disable-bdjava"
                 ++ optional (! withMetadata) "--without-libxml2"
                 ++ optional (! withFonts) "--without-freetype"
                 ;

  # Fix search path for BDJ jarfile
  patches = stdenv.lib.optional withJava ./BDJ-JARFILE-path.patch;

  meta = with stdenv.lib; {
    homepage = http://www.videolan.org/developers/libbluray.html;
    description = "Library to access Blu-Ray disks for video playback";
    license = licenses.lgpl21;
    maintainers = [ maintainers.abbradar ];
  };
}
