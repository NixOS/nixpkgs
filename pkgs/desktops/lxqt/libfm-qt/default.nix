{
  lib, mkDerivation, fetchFromGitHub, cmake, pkgconfig, lxqt-build-tools,
  pcre, libexif, xorg, libfm, menu-cache,
  qtx11extras, qttools
}:

mkDerivation rec {
  pname = "libfm-qt";
  version = "0.14.1";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = pname;
    rev = version;
    sha256 = "00rn5i16h659zyp1dx213nc3jz7rx9phiw71zf6nspxzxsb8w2sc";
  };

  nativeBuildInputs = [
    cmake
    pkgconfig
    lxqt-build-tools
  ];

  buildInputs = [
    pcre
    libexif
    xorg.libpthreadstubs
    xorg.libxcb
    xorg.libXdmcp
    qtx11extras
    qttools
    libfm
    menu-cache
  ];

  meta = with lib; {
    description = "Core library of PCManFM-Qt (Qt binding for libfm)";
    homepage = https://github.com/lxqt/libfm-qt;
    license = licenses.lgpl21;
    platforms = with platforms; unix;
    maintainers = with maintainers; [ romildo ];
  };
}
