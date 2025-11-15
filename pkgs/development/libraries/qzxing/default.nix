{
  stdenv,
  lib,
  fetchFromGitHub,
  nix-update-script,
  testers,
  qmake,
  qtmultimedia,
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

  # greaterThan/lessThan don't handle versions, use versionAtLeast/versionAtMost instead
  # Versions are different due to versionAtLeast/-Most using an inclusive limit, while greater-/lessThan use exclusive ones
  postPatch = ''
    substituteInPlace src/QZXing-components.pri \
      --replace-fail 'lessThan(QT_VERSION, 6.2)' 'versionAtMost(QT_VERSION, 6.1)' \
      --replace-fail 'greaterThan(QT_VERSION, 6.1)' 'versionAtLeast(QT_VERSION, 6.2)'
  '';

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

  meta = {
    description = "Qt/QML wrapper library for the ZXing library";
    homepage = "https://github.com/ftylitak/qzxing";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ OPNA2608 ];
    platforms = lib.platforms.unix;
    pkgConfigModules = [
      "QZXing"
    ];
  };
})
