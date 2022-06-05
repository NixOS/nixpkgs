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
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = "libfm-qt";
    rev = version;
    sha256 = "kF3u1Eh45l/HvL5R0PazIfGIdOVYyB2VAI33NwRfLJk=";
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
    maintainers = teams.lxqt.members;
  };
}
