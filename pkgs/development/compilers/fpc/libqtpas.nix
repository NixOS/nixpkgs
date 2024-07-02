{ stdenv
, lib
, lazarus
, qmake
, qtbase
, qtx11extras ? null
}:

let
  vers = lib.versions.major qtbase.version;

in
stdenv.mkDerivation {
  pname = "libqt${vers}pas";
  inherit (lazarus) version src;

  sourceRoot = "lazarus/lcl/interfaces/qt${vers}/cbindings";

  postPatch = ''
    substituteInPlace Qt${vers}Pas.pro \
      --replace-fail 'target.path = $$[QT_INSTALL_LIBS]' "target.path = $out/lib"
  '';

  nativeBuildInputs = [ qmake ];

  buildInputs = [ qtbase qtx11extras ];

  env.LANG = "C.UTF-8";

  dontWrapQtApps = true;

  meta = {
    description = "Free Pascal Qt${vers} binding library";
    homepage = "https://wiki.freepascal.org/Qt${vers}_Interface";
    maintainers = with lib.maintainers; [ sikmir ];
    inherit (lazarus.meta) license platforms;
  };
}
