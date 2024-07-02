{ stdenv
, lib
, lazarus
, fetchpatch
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

  patches = lib.optionals (vers == "6") [
    (fetchpatch {
      url = "https://gitlab.archlinux.org/archlinux/packaging/packages/qt6pas/-/raw/main/qt-6.7.patch?ref_type=95e0f58f6827497e28faa47d6be033e69084e0ae";
      hash = "sha256-ffq0pOf6SqrTlu4R2Gb0MRkrBc52A1/KnaJNy7NwQ5E=";
      name = "qt-6.7.patch";
    })
  ];

  # instead of changing directory here, we can use sourceRoot as long as we are not fetching patches
  # that expect to be invoked from the root
  postPatch = ''
    cd "lcl/interfaces/qt${vers}/cbindings"

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
