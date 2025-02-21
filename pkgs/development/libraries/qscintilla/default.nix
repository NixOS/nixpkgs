{ stdenv
, lib
, fetchurl
, unzip
, qtbase
, qtmacextras ? null
, qmake
, fixDarwinDylibNames
, darwin
}:

let
  stdenv' = if stdenv.hostPlatform.isDarwin then
    darwin.apple_sdk_11_0.stdenv
  else
    stdenv
  ;
in stdenv'.mkDerivation rec {
  pname = "qscintilla-qt5";
  version = "2.13.2";

  src = fetchurl {
    url = "https://www.riverbankcomputing.com/static/Downloads/QScintilla/${version}/QScintilla_src-${version}.tar.gz";
    sha256 = "sha256-tsfl8ntR0l8J/mz4Sumn8Idq8NZdjMtVEQnm57JYhfQ=";
  };

  sourceRoot = "QScintilla_src-${version}/src";

  buildInputs = [ qtbase ];

  propagatedBuildInputs = lib.optionals stdenv.hostPlatform.isDarwin [ qtmacextras ];

  nativeBuildInputs = [ unzip qmake ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [ fixDarwinDylibNames ];

  # Make sure that libqscintilla2.so is available in $out/lib since it is expected
  # by some packages such as sqlitebrowser
  postFixup = ''
    ln -s $out/lib/libqscintilla2_qt5.so $out/lib/libqscintilla2.so
  '';

  dontWrapQtApps = true;

  preConfigure = ''
    substituteInPlace qscintilla.pro \
      --replace '$$[QT_INSTALL_LIBS]'         $out/lib \
      --replace '$$[QT_INSTALL_HEADERS]'      $out/include \
      --replace '$$[QT_INSTALL_TRANSLATIONS]' $out/translations \
      --replace '$$[QT_HOST_DATA]/mkspecs'    $out/mkspecs \
      --replace '$$[QT_INSTALL_DATA]'         $out/share
  '';

  meta = with lib; {
    description = "Qt port of the Scintilla text editing library";
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
    platforms = platforms.unix;
    # ld: library not found for -lcups
    broken = stdenv.hostPlatform.isDarwin && lib.versionAtLeast qtbase.version "6";
  };
}
