{ stdenv
, lib
, fetchFromGitHub
, nix-update-script
, testers
, qmake
, qtmultimedia
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "qzxing";
  version = "3.3.0";

  src = fetchFromGitHub {
    owner = "ftylitak";
    repo = "qzxing";
    rev = "v${finalAttrs.version}";
    hash = "sha256-ASgsF5ocNWAiIy2jm6ygpDkggBcEpno6iVNWYkuWcVI=";
  };

  # QMake can't find qtmultimedia in buildInputs
  strictDeps = false;

  nativeBuildInputs = [
    qmake
  ];

  buildInputs = [
    qtmultimedia
  ];

  dontWrapQtApps = true;

  preConfigure = ''
    cd src
  '';

  qmakeFlags = [
    "CONFIG+=qzxing_qml"
    "CONFIG+=qzxing_multimedia"
    "QMAKE_PKGCONFIG_PREFIX=${placeholder "out"}"
  ];

  passthru = {
    tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "Qt/QML wrapper library for the ZXing library";
    homepage = "https://github.com/ftylitak/qzxing";
    license = licenses.asl20;
    maintainers = with maintainers; [ OPNA2608 ];
    platforms = platforms.unix;
    pkgConfigModules = [
      "QZXing"
    ];
  };
})
