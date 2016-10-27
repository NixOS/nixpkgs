{ stdenv, fetchFromGitHub, cmake, qt5, kde5, lxqt, xorg, polkit }:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "lxqt-admin";
  version = "0.11.0";

  srcs = fetchFromGitHub {
    owner = "lxde";
    repo = pname;
    rev = version;
    sha256 = "17g9v6dyqy5pgpqragpf0sgnfxz2ip2g7xix7kmkna3qyym44b23";
  };

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    qt5.qtx11extras
    qt5.qttools
    qt5.qtsvg
    kde5.kwindowsystem
    lxqt.liblxqt
    lxqt.libqtxdg
    polkit
  ];

  cmakeFlags = [ "-DPULL_TRANSLATIONS=NO" ];

  postPatch = lxqt.standardPatch;

  meta = with stdenv.lib; {
    description = "LXQt system administration tool";
    homepage = https://github.com/lxde/lxqt-admin;
    license = licenses.lgpl21;
    maintainers = with maintainers; [ romildo ];
    platforms = with platforms; unix;
  };
}
