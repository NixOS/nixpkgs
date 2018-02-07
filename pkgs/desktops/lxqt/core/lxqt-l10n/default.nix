{ stdenv, fetchFromGitHub, cmake, qt5, lxqt }:

stdenv.mkDerivation rec {
  name = "lxqt-l10n-${version}";
  version = "0.12.0";

  src = fetchFromGitHub {
    owner = "lxde";
    repo = "lxqt-l10n";
    rev = version;
    sha256 = "025zg5y9f286p74rab4yxyz4cqlh4hqjq43xxpi76ma2fy2s03a4";
  };

  nativeBuildInputs = [
    cmake
    qt5.qttools
    lxqt.lxqt-build-tools
  ];

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace "\''${LXQT_TRANSLATIONS_DIR}" "$out"/share/lxqt/translations
  '';
  
  meta = with stdenv.lib; {
    description = "Translations of LXQt";
    homepage = https://github.com/lxde/lxqt-l10n;
    license = licenses.lgpl21Plus;
    platforms = with platforms; unix;
    maintainers = with maintainers; [ romildo ];
  };
}
