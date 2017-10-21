{ stdenv, fetchFromGitHub, cmake, pkgconfig, qt5, lxqt, libfm, menu-cache, lxmenu-data }:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "pcmanfm-qt";
  version = "0.11.3";

  srcs = fetchFromGitHub {
    owner = "lxde";
    repo = pname;
    rev = version;
    sha256 = "04vhfhjmz1a4rhkpb6y35hwg565047rp53rcxf4pdn0i9f6zhr4f";
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
    lxqt.libfm-qt
    libfm
    menu-cache
    lxmenu-data
  ];

  cmakeFlags = [ "-DPULL_TRANSLATIONS=NO" ];

  meta = with stdenv.lib; {
    description = "File manager and desktop icon manager (Qt port of PCManFM and libfm)";
    homepage = https://github.com/lxde/pcmanfm-qt;
    license = licenses.gpl2;
    platforms = with platforms; unix;
    maintainers = with maintainers; [ romildo ];
  };
}
