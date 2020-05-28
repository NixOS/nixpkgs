{ stdenv
, mkDerivation
, fetchFromGitHub
, pkg-config
, cmake
, dtkwidget
, qttools
, deepin
}:

mkDerivation rec {
  pname = "deepin-calculator";
  version = "5.5.28";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    sha256 = "00ld72rrfijhiqzhvhy2lyn7x2hmlmpdf7kksxajy2c7kzv3h0jp";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    qttools
    deepin.setupHook
  ];

  buildInputs = [
    dtkwidget
  ];

  postPatch = ''
    searchHardCodedPaths  # debugging
    patchShebangs translate_generation.sh
    fixPath $out /usr CMakeLists.txt
    substituteInPlace deepin-calculator.desktop --replace Exec=deepin-calculator Exec=$out/bin/deepin-calculator
  '';

  postFixup = ''
    searchHardCodedPaths $out  # debugging
  '';

  passthru.updateScript = deepin.updateScript { inherit pname version src; };

  meta = with stdenv.lib; {
    description = "Easy to use calculator for Deepin Desktop Environment";
    homepage = "https://github.com/linuxdeepin/deepin-calculator";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ romildo ];
  };
}
