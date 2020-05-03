{ lib
, mkDerivation
, fetchFromGitHub
, cmake
, pkgconfig
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
  version = "0.15.0";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = "libfm-qt";
    rev = version;
    sha256 = "0isshh627zr69kdmjxsy75i1nh95ky2wfhgy90g8j4zijpkdrd3l";
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

  passthru.updateScript = lxqtUpdateScript { inherit pname version src; };

  meta = with lib; {
    description = "Core library of PCManFM-Qt (Qt binding for libfm)";
    homepage = "https://github.com/lxqt/libfm-qt";
    license = licenses.lgpl21;
    platforms = with platforms; unix;
    maintainers = with maintainers; [ romildo ];
  };
}
