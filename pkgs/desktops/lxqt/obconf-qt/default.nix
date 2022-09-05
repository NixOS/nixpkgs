{ lib
, mkDerivation
, fetchFromGitHub
, cmake
, pkg-config
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
  version = "0.16.2";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = pname;
    rev = version;
    sha256 = "zxwQfKowgpLjfxSV2t7Ly8o7DFqoIxi60zIVCcKDQWo=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
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
    homepage = "https://github.com/lxqt/obconf-qt";
    description = "The Qt port of obconf, the Openbox configuration tool";
    license = licenses.gpl2Plus;
    platforms = with platforms; unix;
    maintainers = teams.lxqt.members;
  };
}
