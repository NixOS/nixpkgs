{ stdenv, fetchFromGitHub, cmake, qt5, lxqt }:

stdenv.mkDerivation rec {
  name = "lxqt-l10n-${version}";
  version = "0.13.0";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = "lxqt-l10n";
    rev = version;
    sha256 = "0q1hzj6sa4wc8sgqqqsqfldjpnvihacfq73agvc2li3q6qi5rr0k";
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
    homepage = https://github.com/lxqt/lxqt-l10n;
    license = licenses.lgpl21Plus;
    platforms = with platforms; unix;
    maintainers = with maintainers; [ romildo ];
  };
}
