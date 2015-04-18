{ stdenv, fetchurl, libgcrypt, yacc, flex }:

# library that allows libbluray to play AACS protected bluray disks
# libaacs does not infringe DRM's right or copyright. See the legal page of the website for more info.

# Info on how to use / obtain aacs keys:
# http://vlc-bluray.whoknowsmy.name/
# https://wiki.archlinux.org/index.php/BluRay


let baseName = "libaacs";
    version  = "0.8.0";
in

stdenv.mkDerivation {
  name = "${baseName}-${version}";

  src = fetchurl {
    url = "http://download.videolan.org/pub/videolan/${baseName}/${version}/${baseName}-${version}.tar.bz2";
    sha256 = "155sah8z4vbp6j3sq9b17mcn6rj1938ijszz97m8pd2cgif58i2y";
  };

  buildInputs = [ libgcrypt ];

  nativeBuildInputs = [ yacc flex ];

  meta = with stdenv.lib; {
    homepage = http://www.videolan.org/developers/libbluray.html;
    description = "Library to access Blu-Ray disks for video playback";
    license = licenses.lgpl21;
    maintainers = with maintainers; [ abbradar ];
  };
}
