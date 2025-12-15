{
  lib,
  stdenv,

  fetchurl,
  unzip,
  qtbase,
  qtmacextras ? null,
  qmake,
  fixDarwinDylibNames,
}:

let
  qtVersion = lib.versions.major qtbase.version;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "qscintilla-qt${qtVersion}";
  version = "2.14.1";

  src = fetchurl {
    url = "https://www.riverbankcomputing.com/static/Downloads/QScintilla/${finalAttrs.version}/QScintilla_src-${finalAttrs.version}.tar.gz";
    sha256 = "sha256-3+E8asydhd/Lp2zMgGHnGiI5V6bALzw0OzCp1DpM3U0=";
  };

  sourceRoot = "QScintilla_src-${finalAttrs.version}/src";

  buildInputs = [ qtbase ];

  propagatedBuildInputs = lib.optionals stdenv.hostPlatform.isDarwin [ qtmacextras ];

  nativeBuildInputs = [
    unzip
    qmake
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [ fixDarwinDylibNames ];

  # Make sure that libqscintilla2.so is available in $out/lib since it is expected
  # by some packages such as sqlitebrowser
  postFixup =
    let
      libExt = stdenv.hostPlatform.extensions.sharedLibrary;
    in
    ''
      ln -s $out/lib/libqscintilla2_qt${qtVersion}${libExt} $out/lib/libqscintilla2${libExt}
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

  meta = {
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
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ peterhoeg ];
    platforms = lib.platforms.unix;
  };
})
