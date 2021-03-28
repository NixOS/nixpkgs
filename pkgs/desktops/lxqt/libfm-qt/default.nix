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
  version = "0.16.0";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = "libfm-qt";
    rev = version;
    sha256 = "0b52bczqvw4brxv5fszjrl1375yid6xzjm49ns9rx1jw71422w0p";
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
