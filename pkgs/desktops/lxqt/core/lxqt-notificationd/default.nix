{ stdenv, fetchFromGitHub, cmake, qt5, kde5, lxqt }:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "lxqt-notificationd";
  version = "0.11.0";

  srcs = fetchFromGitHub {
    owner = "lxde";
    repo = pname;
    rev = version;
    sha256 = "001xcvmg7ap5pbssc9pqp4jshgq2h4zxk9rra76xnrby6k8n6p3x";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [
    qt5.qtbase
    qt5.qttools
    qt5.qtsvg
    kde5.kwindowsystem
    lxqt.liblxqt
    lxqt.libqtxdg
  ];

  cmakeFlags = [ "-DPULL_TRANSLATIONS=NO" ];

  meta = with stdenv.lib; {
    description = "The LXQt notification daemon";
    homepage = https://github.com/lxde/lxqt-notificationd;
    license = licenses.lgpl21;
    maintainers = with maintainers; [ romildo ];
    platforms = with platforms; unix;
  };
}
