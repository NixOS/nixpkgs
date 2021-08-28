{ lib
, mkDerivation
, fetchFromGitHub
, cmake
, pkg-config
, lxqt-build-tools
, pcre
, libexif
, xorg
, libfm
, menu-cache
, qtx11extras
, qttools
, lxqtUpdateScript
}:

mkDerivation rec {
  pname = "libfm-qt";
  version = "0.17.1";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = "libfm-qt";
    rev = version;
    sha256 = "0jdsqvwp81y4ylabrqdc673x80fp41rpp5w7c1v9zmk9k8z4s5ll";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
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

  passthru.updateScript = lxqtUpdateScript { inherit pname version src; };

  meta = with lib; {
    homepage = "https://github.com/lxqt/libfm-qt";
    description = "Core library of PCManFM-Qt (Qt binding for libfm)";
    license = licenses.lgpl21Plus;
    platforms = with platforms; unix;
    maintainers = with maintainers; [ romildo ];
  };
}
