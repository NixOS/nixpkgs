{ stdenv, fetchFromGitHub, cmake, qt5, kde5, lxqt }:

stdenv.mkDerivation rec {
  name = "lxqt-l10n-${version}";
  version = "0.11.0";

  src = fetchFromGitHub {
    owner = "lxde";
    repo = "lxqt-l10n";
    rev = version;
    sha256 = "1gwismyjfdd7lwlgfl5jvbxmkbq9v9ia0shm4f7hkkvlpc2y24gk";
  };

  nativeBuildInputs = [
    cmake
    qt5.qtbase
    qt5.qtx11extras
    qt5.qttools
    qt5.qtsvg
    kde5.kwindowsystem
    lxqt.liblxqt
    lxqt.libqtxdg
  ];

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace "\''${LXQT_TRANSLATIONS_DIR}" "$out"/share/lxqt/translations
  '';
  
  meta = with stdenv.lib; {
    description = "Translations of LXQt";
    homepage = https://github.com/lxde/lxqt-l10n;
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ romildo ];
    platforms = with platforms; unix;
  };
}
