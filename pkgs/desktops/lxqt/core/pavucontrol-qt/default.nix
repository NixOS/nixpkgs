{ stdenv, fetchFromGitHub, cmake, pkgconfig, qt5, lxqt, libpulseaudio }:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "pavucontrol-qt";
  version = "0.2.0";

  srcs = fetchFromGitHub {
    owner = "lxde";
    repo = pname;
    rev = version;
    sha256 = "0k7sg4dxr48nk15gpqlnkjr9gbh7r5gs0s0ydifcmw281khrzlzj";
  };

  nativeBuildInputs = [
    cmake
    pkgconfig
    lxqt.lxqt-build-tools
  ];

  buildInputs = [
    qt5.qtbase
    qt5.qttools
    qt5.qtx11extras
    libpulseaudio
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
