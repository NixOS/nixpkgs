{ stdenv, fetchFromGitHub, cmake, qt5, kde5, lxqt, xorg }:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "lxqt-about";
  version = "0.11.0";

  srcs = fetchFromGitHub {
    owner = "lxde";
    repo = pname;
    rev = version;
    sha256 = "0739gp3af68cvf8fxqvd203xqzncglmxpklq8mryrs5f1xnqp6gc";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [
    qt5.qtx11extras
    qt5.qttools
    qt5.qtsvg
    kde5.kwindowsystem
    lxqt.liblxqt
    lxqt.libqtxdg
  ];

  cmakeFlags = [ "-DPULL_TRANSLATIONS=NO" ];

  postPatch = lxqt.standardPatch;

  meta = with stdenv.lib; {
    description = "Dialogue window providing information about LXQt and the system it's running on";
    homepage = https://github.com/lxde/lxqt-about;
    license = licenses.lgpl21;
    maintainers = with maintainers; [ romildo ];
    platforms = with platforms; unix;
  };
}
