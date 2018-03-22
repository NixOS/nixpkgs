{ stdenv, fetchFromGitHub, cmake, pkgconfig, lxqt, libpulseaudio, pcre, qtbase, qttools, qtx11extras }:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "pavucontrol-qt";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "lxde";
    repo = pname;
    rev = version;
    sha256 = "1pfqdzsbygvq77npsizydps25d9g6vgw177yqvmz3cg3a68dad27";
  };

  nativeBuildInputs = [
    cmake
    pkgconfig
    lxqt.lxqt-build-tools
  ];

  buildInputs = [
    qtbase
    qttools
    qtx11extras
    libpulseaudio
    pcre
  ];

  cmakeFlags = [ "-DPULL_TRANSLATIONS=NO" ];

  meta = with stdenv.lib; {
    description = "A Pulseaudio mixer in Qt (port of pavucontrol)";
    homepage = https://github.com/lxde/pavucontrol-qt;
    license = licenses.gpl2;
    platforms = with platforms; unix;
    maintainers = with maintainers; [ romildo ];
  };
}
