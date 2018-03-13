{ stdenv, lib, fetchurl, unzip
, qt4 ? null, qmake4Hook ? null
, withQt5 ? false, qtbase ? null, qtmacextras ? null, qmake ? null
}:

# Fix Xcode 8 compilation problem
let xcodePatch =
  fetchurl { url = "https://raw.githubusercontent.com/Homebrew/formula-patches/a651d71/qscintilla2/xcode-8.patch";
             sha256 = "1a88309fdfd421f4458550b710a562c622d72d6e6fdd697107e4a43161d69bc9"; };
in
stdenv.mkDerivation rec {
  pname = "qscintilla";
  version = "2.9.4";

  name = "${pname}-${if withQt5 then "qt5" else "qt4"}-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/pyqt/QScintilla2/QScintilla-${version}/QScintilla_gpl-${version}.zip";
    sha256 = "04678skipydx68zf52vznsfmll2v9aahr66g50lcqbr6xsmgr1yi";
  };

  buildInputs = [ (if withQt5 then qtbase else qt4) ]
    ++ lib.optional (withQt5 && stdenv.isDarwin) qtmacextras;
  nativeBuildInputs = [ unzip ]
    ++ (if withQt5 then [ qmake ] else [ qmake4Hook ]);


  patches = [] ++ lib.optional withQt5 [ xcodePatch ];

  enableParallelBuilding = true;

  preConfigure = ''
    cd Qt4Qt5
    sed -i qscintilla.pro \
      -e "s,\$\$\\[QT_INSTALL_LIBS\\],$out/lib," \
      -e "s,\$\$\\[QT_INSTALL_HEADERS\\],$out/include/," \
      -e "s,\$\$\\[QT_INSTALL_TRANSLATIONS\\],$out/translations," \
    ${if withQt5 then ''
      -e "s,\$\$\\[QT_HOST_DATA\\]/mkspecs,$out/mkspecs," \
      -e "s,\$\$\\[QT_INSTALL_DATA\\]/mkspecs,$out/mkspecs," \
      -e "s,\$\$\\[QT_INSTALL_DATA\\],$out/share,"
    '' else ''
      -e "s,\$\$\\[QT_INSTALL_DATA\\],$out/share/qt,"
    ''}
  '';

  meta = with stdenv.lib; {
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
    homepage = http://www.riverbankcomputing.com/software/qscintilla/intro;
    license = with licenses; [ gpl2 gpl3 ]; # and commercial
    platforms = platforms.unix;
    maintainers = with maintainers; [ peterhoeg ];
  };
}
