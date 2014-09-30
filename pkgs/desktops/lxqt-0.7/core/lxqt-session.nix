{ stdenv, fetchgit, pkgconfig
, cmake
, qt48

, libqtxdg
, liblxqt
}:

stdenv.mkDerivation rec {
  basename = "lxqt-session";
  version = "0.7.0";
  name = "${basename}-${version}";

  src = fetchgit {
    url = "https://github.com/lxde/${basename}.git";
    rev = "1de464107a9dedb46f7424e8fd35d5e774327314";
    sha256 = "dc7d34081bd833eb5578cdffe98de0f1aececf5641d141854d42c6bad7132af9";
  };

  buildInputs = [
    stdenv pkgconfig
    cmake qt48
    libqtxdg liblxqt
  ];

  meta = {
    homepage = "http://www.lxqt.org";
    description = "session manager";
    license = stdenv.lib.licenses.lgpl21;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.ellis ];
  };
}
