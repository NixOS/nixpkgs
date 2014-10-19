{ stdenv, fetchgit, pkgconfig
, cmake
, qt48

, polkit_qt_1
, libqtxdg
, liblxqt
}:

stdenv.mkDerivation rec {
  basename = "lxqt-policykit";
  version = "0.7.0";
  name = "${basename}-${version}";

  src = fetchgit {
    url = "https://github.com/lxde/${basename}.git";
    rev = "6b07fdde4c99989128d1ed4cd7cb240a3743e97d";
    sha256 = "c63d752669659a784974dec5cc740f7be22ffb11616d0132a38267f579ca4049";
  };

  buildInputs = [
    stdenv pkgconfig
    cmake qt48
    polkit_qt_1
    libqtxdg liblxqt
  ];

  meta = {
    homepage = "http://www.lxqt.org";
    description = "Policykit authentication agent";
    license = stdenv.lib.licenses.lgpl21;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.ellis ];
  };
}
