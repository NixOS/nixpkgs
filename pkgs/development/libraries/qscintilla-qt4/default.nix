{ stdenv
, lib
, fetchurl
, unzip
, qt4
, qmake4Hook
}:

stdenv.mkDerivation rec {
  pname = "qscintilla-qt4";
  version = "2.11.6";

  src = fetchurl {
    url = "https://www.riverbankcomputing.com/static/Downloads/QScintilla/${version}/QScintilla-${version}.tar.gz";
    sha256 = "5zRgV9tH0vs4RGf6/M/LE6oHQTc8XVk7xytVsvDdIKc=";
  };

  sourceRoot = "QScintilla-${version}/Qt4Qt5";

  buildInputs = [ qt4 ];

  nativeBuildInputs = [ unzip qmake4Hook ];

  patches = [
    ./fix-qt4-build.patch
  ];

  # Make sure that libqscintilla2.so is available in $out/lib since it is expected
  # by some packages such as sqlitebrowser
  postFixup = ''
    ln -s $out/lib/libqscintilla2_qt4.so $out/lib/libqscintilla2.so
  '';

  dontWrapQtApps = true;

  postPatch = ''
    substituteInPlace qscintilla.pro \
      --replace '$$[QT_INSTALL_LIBS]'         $out/lib \
      --replace '$$[QT_INSTALL_HEADERS]'      $out/include \
      --replace '$$[QT_INSTALL_TRANSLATIONS]' $out/translations \
      --replace '$$[QT_HOST_DATA]/mkspecs'    $out/mkspecs \
      --replace '$$[QT_INSTALL_DATA]/mkspecs' $out/mkspecs \
      --replace '$$[QT_INSTALL_DATA]'         $out/share
  '';

  meta = with lib; {
    description = "A Qt port of the Scintilla text editing library";
    longDescription = ''
      QScintilla is a port to Qt of Neil Hodgson's Scintilla C++ editor
      control.

      As well as features found in standard text editing components,
      QScintilla includes features especially useful when editing and
      debugging source code. These include support for syntax styling,
      error indicators, code completion and call tips. The selection
      margin can contain markers like those used in debuggers to
      indicate breakpoints and the current line. Styling choices are
      more open than with many editors, allowing the use of
      proportional fonts, bold and italics, multiple foreground and
      background colours and multiple fonts.
    '';
    homepage = "https://www.riverbankcomputing.com/software/qscintilla/intro";
    license = with licenses; [ gpl3 ]; # and commercial
    maintainers = with maintainers; [ peterhoeg ];
    platforms = platforms.linux;
  };
}
