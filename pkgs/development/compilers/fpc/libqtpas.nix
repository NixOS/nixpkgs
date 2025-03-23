{
  stdenv,
  lib,
  lazarus,
  qmake,
  qtbase,
  # Not in Qt6 anymore
  qtx11extras ? null,
}:

let
  qtVersion = lib.versions.major qtbase.version;
in
stdenv.mkDerivation {
  pname = "libqtpas";
  inherit (lazarus) version src;

  sourceRoot = "lazarus/lcl/interfaces/qt${qtVersion}/cbindings";

  postPatch = ''
    substituteInPlace Qt${qtVersion}Pas.pro \
      --replace 'target.path = $$[QT_INSTALL_LIBS]' "target.path = $out/lib"
  '';

  nativeBuildInputs = [ qmake ];

  buildInputs =
    [
      qtbase
    ]
    ++ lib.optionals (qtVersion == "5") [
      qtx11extras
    ];

  dontWrapQtApps = true;

  meta = with lib; {
    description = "Free Pascal Qt${qtVersion} binding library";
    homepage =
      "https://wiki.freepascal.org/Qt${qtVersion}_Interface"
      + lib.optionalString (qtVersion == "5") "#libqt5pas";
    maintainers = with maintainers; [ sikmir ];
    inherit (lazarus.meta) license platforms;
  };
}
