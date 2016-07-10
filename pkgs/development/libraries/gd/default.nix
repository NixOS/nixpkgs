{stdenv, fetchgit, zlib, libpng, freetype, libjpeg, fontconfig}:

stdenv.mkDerivation {
  name = "gd-2.0.36pre";

  src = fetchgit {
    url = git://anonscm.debian.org/collab-maint/libgd2.git;
    rev = "787b93feeea519d7cac40d59a264280e31c0b01c"; # master-wheezy "now"
    sha256 = "003wm1av6l8bmcrl7w5bs1az1mw325bp5a8hxdq99l0ypw0f3xd2";
  };
  prePatch = ''
    for p in $(cat debian/patches/series); do
      echo "Applying '$p':"
      patch -p1 < "debian/patches/$p"
    done
  '';

  buildInputs = [zlib libpng freetype];

  propagatedBuildInputs = [libjpeg fontconfig]; # urgh

  configureFlags = "--without-x";

  meta = {
    homepage = http://www.libgd.org/;
    description = "An open source code library for the dynamic creation of images by programmers";
  };
}
