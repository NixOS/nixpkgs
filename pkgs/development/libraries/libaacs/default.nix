{ stdenv, fetchurl, libgcrypt, libgpgerror, yacc, flex }:

# library that allows libbluray to play AACS protected bluray disks
# libaacs does not infringe DRM's right or copyright. See the legal page of the website for more info.

# Info on how to use / obtain aacs keys:
# http://vlc-bluray.whoknowsmy.name/
# https://wiki.archlinux.org/index.php/BluRay

stdenv.mkDerivation rec {
  name = "libaacs-${version}";
  version  = "0.9.0";

  src = fetchurl {
    url = "http://get.videolan.org/libaacs/${version}/${name}.tar.bz2";
    sha256 = "1kms92i0c7i1yl659kqjf19lm8172pnpik5lsxp19xphr74vvq27";
  };

  buildInputs = [ libgcrypt libgpgerror ];

  nativeBuildInputs = [ yacc flex ];

  meta = with stdenv.lib; {
    homepage = https://www.videolan.org/developers/libaacs.html;
    description = "Library to access AACS protected Blu-Ray disks";
    license = licenses.lgpl21;
    maintainers = with maintainers; [ abbradar ];
    platforms = with platforms; linux;
  };
}
