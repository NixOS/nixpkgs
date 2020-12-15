{ lib
, mkDerivation
, fetchFromGitHub
, cmake
, pkgconfig
, pcre
, qtbase
, qttools
, qtx11extras
, xorg
, lxqt-build-tools
, openbox
, lxqtUpdateScript
}:

mkDerivation rec {
  pname = "obconf-qt";
  version = "0.16.0";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = pname;
    rev = version;
    sha256 = "0kk5scp1j0hqi27q3yl9cg73ybxzm22nj96pa8adhdn4shg9bpac";
  };

  nativeBuildInputs = [
    cmake
    pkgconfig
    lxqt-build-tools
  ];

  buildInputs = [
    pcre
    qtbase
    qttools
    qtx11extras
    xorg.libpthreadstubs
    xorg.libXdmcp
    xorg.libSM
    openbox
  ];

  passthru.updateScript = lxqtUpdateScript { inherit pname version src; };

  meta = with lib; {
    description = "The Qt port of obconf, the Openbox configuration tool";
    homepage = "https://github.com/lxqt/obconf-qt";
    license = licenses.gpl2;
    platforms = with platforms; unix;
    maintainers = with maintainers; [ romildo ];
  };
}
