{ stdenv, fetchurl, pkgconfig, gnome3, intltool }:

stdenv.mkDerivation rec {
  name = "gnome-backgrounds-${version}";
  version = "3.26.2";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-backgrounds/${gnome3.versionBranch version}/${name}.tar.xz";
    sha256 = "3a8ba8d3463d70bce2377b168218e32367c0020f2d0caf611e7e39066081f94f";
  };

  passthru = {
    updateScript = gnome3.updateScript { packageName = "gnome-backgrounds"; attrPath = "gnome3.gnome-backgrounds"; };
  };

  nativeBuildInputs = [ pkgconfig intltool ];

  meta = with stdenv.lib; {
    platforms = platforms.unix;
    maintainers = gnome3.maintainers;
  };
}
