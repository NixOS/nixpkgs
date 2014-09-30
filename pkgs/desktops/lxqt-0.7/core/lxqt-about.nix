{ stdenv, fetchgit, pkgconfig
, cmake
, qt48

#, libqtxdg
, liblxqt
}:

stdenv.mkDerivation rec {
  basename = "lxqt-about";
  version = "0.7.0";
  name = "${basename}-${version}";

  src = fetchgit {
    url = "https://github.com/lxde/${basename}.git";
    rev = "11ec27fd2d0ddce685add5c4db7eceb5bdc39d19";
    sha256 = "c92030babb0737c0d770e3cb4bfeab86afccf5a3b44a00c9cefc5a37caa3d665";
  };

  buildInputs = [
    stdenv pkgconfig
    cmake qt48
    liblxqt
  ];

  meta = {
    homepage = "http://www.lxqt.org";
    description = "About dialog for lxde-qt";
    license = stdenv.lib.licenses.lgpl21;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.ellis ];
  };
}
