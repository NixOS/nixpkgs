{ stdenv, fetchgit
, cmake
, qt48

# lxqt dependencies
, liblxqt
}:

stdenv.mkDerivation rec {
  basename = "lxqt-globalkeys";
  version = "0.7.0";
  name = "${basename}-${version}";

  src = fetchgit {
    url = "https://github.com/lxde/${basename}.git";
    rev = "5ceb74d79140fa487535cee17854db2aba99bdb4";
    sha256 = "58af2329f4d01cbe7fdb55fbd13fdadd4db99fa616f34ea1c0bb5316e14791eb";
  };

  buildInputs = [ stdenv cmake qt48 liblxqt ];

  #preConfigure = ''cmakeFlags="-DLXQT_ETC_XDG_DIR=$out/etc/xdg"'';

  #preInstall = ''mkdir -p $out/etc/xdg'';

  meta = {
    homepage = "http://www.lxqt.org";
    description = "Daemon and library for global keyboard shortcuts registration";
    license = stdenv.lib.licenses.lgpl21;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.ellis ];
  };
}
