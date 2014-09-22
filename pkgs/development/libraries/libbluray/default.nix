{ stdenv, fetchurl, pkgconfig
, withAACS ? false, libaacs ? null, jdk ? null, ant ? null
, withMetadata ? true, libxml2 ? null
, withFonts ? true, freetype ? null
}:

assert withAACS -> jdk != null && ant != null && libaacs != null;
assert withMetadata -> libxml2 != null;
assert withFonts -> freetype != null;

# Info on how to use:
# https://wiki.archlinux.org/index.php/BluRay

stdenv.mkDerivation rec {
  baseName = "libbluray";
  version  = "0.6.0";
  name = "${baseName}-${version}";

  src = fetchurl {
    url = "ftp://ftp.videolan.org/pub/videolan/${baseName}/${version}/${name}.tar.bz2";
    sha256 = "0zsk16p7rxwbyizm87i7x2fcy3gwjfnlfd2gi2n17fv6gajvsyv2";
  };

  nativeBuildInputs = with stdenv.lib;
                      [pkgconfig]
                      ++ optional withAACS ant
                      ;

  buildInputs =  with stdenv.lib;
                 optionals withAACS [jdk libaacs]
              ++ optional withMetadata libxml2
              ++ optional withFonts freetype
              ;

  configureFlags =  with stdenv.lib;
                    optionals withAACS ["--enable-bdjava" "--with-jdk=${jdk}"]
                 ++ optional (! withMetadata) "--without-libxml2"
                 ++ optional (! withFonts) "--without-freetype"
                 ;

  meta = with stdenv.lib; {
    homepage = http://www.videolan.org/developers/libbluray.html;
    description = "Library to access Blu-Ray disks for video playback";
    license = licenses.lgpl21;
    maintainers = [ maintainers.abbradar ];
  };
}
