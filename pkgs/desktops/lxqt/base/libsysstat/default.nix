{ stdenv, fetchFromGitHub, cmake, qt5, lxqt, fetchurl }:

stdenv.mkDerivation rec {
  name = "libsysstat-${version}";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "lxde";
    repo = "libsysstat";
    rev = version;
    sha256 = "0yl20dj553z1ijkfxl9n45qvkzxyl9rqw12vb4v6zj3ch6hzbzsx";
  };

  patches = [
    # Backport "Drop Qt foreach", I believe the version of QT we are using is too new
    (fetchurl {
      url = "https://github.com/lxqt/libsysstat/commit/e4904ad.patch";
      sha256 = "0d9bza95n0w27lvlx64c93fan4vms236jhx0ysynj3902yzdn5yd";
    })
  ];

  nativeBuildInputs = [ cmake lxqt.lxqt-build-tools qt5.qtbase ];

  buildInputs = with qt5; [ qtbase qtsvg ];

  meta = with stdenv.lib; {
    description = "Library used to query system info and statistics";
    homepage = https://github.com/lxde/libsysstat;
    license = licenses.lgpl21Plus;
    platforms = with platforms; unix;
    maintainers = with maintainers; [ romildo ];
  };
}
