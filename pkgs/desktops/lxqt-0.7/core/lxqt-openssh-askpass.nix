{ stdenv, fetchgit, pkgconfig
, cmake
, qt48

, liblxqt
}:

stdenv.mkDerivation rec {
  basename = "lxqt-openssh-askpass";
  version = "0.7.0";
  name = "${basename}-${version}";

  src = fetchgit {
    url = "https://github.com/lxde/${basename}.git";
    rev = "e193f70354922794ae9c09f79e00c5ce60cbd135";
    sha256 = "166ce92f8f6b1cf7163b08df17e251cd325ea9370e8fe7088cf0bb53b3263e88";
  };

  buildInputs = [
    stdenv pkgconfig
    cmake qt48
    liblxqt
  ];

  meta = {
    homepage = "http://www.lxqt.org";
    description = "Tool used with openssh to prompt the user for password";
    license = stdenv.lib.licenses.lgpl21;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.ellis ];
  };
}
