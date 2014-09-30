{ stdenv, fetchgit, pkgconfig
, cmake
, qt48

, libqtxdg
, liblxqt
}:

stdenv.mkDerivation rec {
  basename = "lxqt-config";
  version = "0.7.0";
  name = "${basename}-${version}";

  src = fetchgit {
    url = "https://github.com/lxde/${basename}.git";
    rev = "b2ce0d1833158eeb6fac7753b2c447cb0a707352";
    sha256 = "14926060f4b05535ea6c05945d69cbb3af37563fbb4c5a0ac90d053d044e1f35";
  };

  buildInputs = [
    stdenv pkgconfig
    cmake qt48
    libqtxdg liblxqt
  ];

  patchPhase = ''
    substituteInPlace src/CMakeLists.txt --replace /etc/xdg $out/etc/xdg
  '';

  meta = {
    homepage = "http://www.lxqt.org";
    description = "System configuration (control center)";
    license = stdenv.lib.licenses.lgpl21;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.ellis ];
  };
}
