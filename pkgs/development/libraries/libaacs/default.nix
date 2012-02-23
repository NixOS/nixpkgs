{stdenv, fetchurl, libgcrypt}:

# library that allows libbluray to play AACS protected bluray disks
# libaacs does not infringe DRM's right or copyright. See the legal page of the website for more info.

# Info on how to use / obtain aacs keys:
# http://vlc-bluray.whoknowsmy.name/
# https://wiki.archlinux.org/index.php/BluRay


let baseName = "libaacs";
    version  = "0.3.0";
in

stdenv.mkDerivation {
  name = "${baseName}-${version}";

  src = fetchurl {
    url = "http://download.videolan.org/pub/videolan/${baseName}/${version}/${baseName}-${version}.tar.bz2";
    sha256 = "bf92dab1a6a8ee08a55e8cf347c2cda49e6535b52e85bb1e92e1cfcc8ecec22c";
  };

  buildInputs = [libgcrypt];

  meta = {
    homepage = http://www.videolan.org/developers/libbluray.html;
    description = "Library to access Blu-Ray disks for video playback";
    license = stdenv.lib.licenses.lgpl21;
  };
}
