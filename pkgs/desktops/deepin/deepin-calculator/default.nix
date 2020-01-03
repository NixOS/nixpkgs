{ stdenv, mkDerivation, fetchFromGitHub, pkgconfig, qmake, qttools, qtsvg, dtkcore,
  dtkwidget, deepin }:

mkDerivation rec {
  pname = "deepin-calculator";
  version = "5.0.1";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    sha256 = "0f26y7b3giybybhvlzbnwcw8kidzvhq66h0c15n9ww81gnlqf7v5";
  };

  nativeBuildInputs = [
    qmake
    pkgconfig
    qttools
    deepin.setupHook
  ];

  buildInputs = [
    dtkcore
    dtkwidget
    qtsvg
  ];

  postPatch = ''
    searchHardCodedPaths  # debugging
    patchShebangs translate_generation.sh
    fixPath $out /usr deepin-calculator.pro
    substituteInPlace deepin-calculator.desktop --replace "Exec=deepin-calculator" "Exec=$out/bin/deepin-calculator"
  '';

  postFixup = ''
    searchHardCodedPaths $out  # debugging
  '';

  passthru.updateScript = deepin.updateScript { name = "${pname}-${version}"; };

  meta = with stdenv.lib; {
    description = "Easy to use calculator for Deepin Desktop Environment";
    homepage = https://github.com/linuxdeepin/deepin-calculator;
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ romildo ];
  };
}
