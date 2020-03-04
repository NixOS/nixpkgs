{ stdenv, lib, fetchurl, unzip
, qt4 ? null, qmake4Hook ? null
, withQt5 ? false, qtbase ? null, qtmacextras ? null, qmake ? null
, fixDarwinDylibNames
}:

let
  # Fix Xcode 8 compilation problem
  xcodePatch = fetchurl {
    url = "https://raw.githubusercontent.com/Homebrew/formula-patches/a651d71/qscintilla2/xcode-8.patch";
    sha256 = "1a88309fdfd421f4458550b710a562c622d72d6e6fdd697107e4a43161d69bc9";
  };

  pname = "qscintilla-qt${if withQt5 then "5" else "4"}";
  version = "2.11.2";

in stdenv.mkDerivation rec {
  inherit pname version;

  src = fetchurl {
    url = "https://www.riverbankcomputing.com/static/Downloads/QScintilla/${version}/QScintilla_gpl-${version}.tar.gz";
    sha256 = "18glb2v07mwfz6p8qmwhzcaaczyc36x3gn9wx8ndm7q6d93xr6q2";
  };

  sourceRoot = "QScintilla_gpl-${version}/Qt4Qt5";

  buildInputs = [ (if withQt5 then qtbase else qt4) ];

  propagatedBuildInputs = lib.optional (withQt5 && stdenv.isDarwin) qtmacextras;

  nativeBuildInputs = [ unzip ]
    ++ (if withQt5 then [ qmake ] else [ qmake4Hook ])
    ++ lib.optional stdenv.isDarwin fixDarwinDylibNames;

  patches = (lib.optional (stdenv.isDarwin && withQt5) xcodePatch) ++
            (lib.optional (!withQt5) ./fix-qt4-build.patch );

  # Make sure that libqscintilla2.so is available in $out/lib since it is expected
  # by some packages such as sqlitebrowser
  postFixup = ''
    ln -s $out/lib/libqscintilla2_qt?.so $out/lib/libqscintilla2.so
  '';

  enableParallelBuilding = true;

  postPatch = ''
    substituteInPlace qscintilla.pro \
      --replace '$$[QT_INSTALL_LIBS]'         $out/lib \
      --replace '$$[QT_INSTALL_HEADERS]'      $out/include \
      --replace '$$[QT_INSTALL_TRANSLATIONS]' $out/translations \
      --replace '$$[QT_HOST_DATA]/mkspecs'    $out/mkspecs \
      --replace '$$[QT_INSTALL_DATA]/mkspecs' $out/mkspecs \
      --replace '$$[QT_INSTALL_DATA]'         $out/share${lib.optionalString (! withQt5) "/qt"}
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
    homepage = https://www.riverbankcomputing.com/software/qscintilla/intro;
    license = with licenses; [ gpl2 gpl3 ]; # and commercial
    maintainers = with maintainers; [ peterhoeg ];
    platforms = platforms.unix;
  };
}
