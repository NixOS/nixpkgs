{ stdenv, fetchFromGitHub, cmake, qt5 }:

stdenv.mkDerivation rec {
  name = "lxqt-build-tools-${version}";
  version = "0.3.2";

  src = fetchFromGitHub {
    owner = "lxde";
    repo = "lxqt-build-tools";
    rev = version;
    sha256 = "1awd70ifbbi67pklhldjw968c1fw1lcif9nh4qbrjqmlg1gn3kmv";
  };

  nativeBuildInputs = [ cmake qt5.qtbase ];

  meta = with stdenv.lib; {
    description = "Various packaging tools and scripts for LXQt applications";
    homepage = https://github.com/lxde/lxqt-build-tools;
    license = licenses.lgpl21;
    platforms = with platforms; unix;
    maintainers = with maintainers; [ romildo ];
  };
}
