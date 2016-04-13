{ stdenv, fetchurl, libgcrypt, libgpgerror, yacc, flex }:

# library that allows libbluray to play AACS protected bluray disks
# libaacs does not infringe DRM's right or copyright. See the legal page of the website for more info.

# Info on how to use / obtain aacs keys:
# http://vlc-bluray.whoknowsmy.name/
# https://wiki.archlinux.org/index.php/BluRay

let baseName = "libaacs";
    version  = "0.8.1";
in

stdenv.mkDerivation {
  name = "${baseName}-${version}";

  src = fetchurl {
    url = "http://get.videolan.org/${baseName}/${version}/${baseName}-${version}.tar.bz2";
    sha256 = "1s5v075hnbs57995r6lljm79wgrip3gnyf55a0y7bja75jh49hwm";
  };

  buildInputs = [ libgcrypt libgpgerror ];

  nativeBuildInputs = [ yacc flex ];

  meta = with stdenv.lib; {
    homepage = https://www.videolan.org/developers/libaacs.html;
    description = "Library to access AACS protected Blu-Ray disks";
    license = licenses.lgpl21;
    maintainers = with maintainers; [ abbradar ];
  };
}
