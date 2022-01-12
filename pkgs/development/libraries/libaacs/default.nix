{ lib, stdenv, fetchurl, libgcrypt, libgpg-error, bison, flex }:

# library that allows libbluray to play AACS protected bluray disks
# libaacs does not infringe DRM's right or copyright. See the legal page of the website for more info.

# Info on how to use / obtain aacs keys:
# http://vlc-bluray.whoknowsmy.name/
# https://wiki.archlinux.org/index.php/BluRay

stdenv.mkDerivation rec {
  pname = "libaacs";
  version  = "0.11.0";

  src = fetchurl {
    url = "http://get.videolan.org/libaacs/${version}/${pname}-${version}.tar.bz2";
    sha256 = "11skjqjlldmbjkyxdcz4fmcn6y4p95r1xagbcnjy4ndnzf0l723d";
  };

  buildInputs = [ libgcrypt libgpg-error ];

  nativeBuildInputs = [ bison flex ];

  meta = with lib; {
    homepage = "https://www.videolan.org/developers/libaacs.html";
    description = "Library to access AACS protected Blu-Ray disks";
    license = licenses.lgpl21;
    maintainers = with maintainers; [ abbradar ];
    platforms = with platforms; linux;
  };
}
