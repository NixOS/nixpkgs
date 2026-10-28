{
  lib,
  stdenv,
  fetchFromGitLab,
  installShellFiles,
  libsForQt5,
  autoPatchelfHook,
}:

stdenv.mkDerivation rec {
  pname = "valentina";
  version = "0.7.53";

  src = fetchFromGitLab {
    owner = "smart-pattern";
    repo = "valentina";
    rev = "v${version}";
    hash = "sha256-vIlqrK7wyFaXKfvcJ3FtkAwUt6Xb/47qxcDGy1Ty2uk=";
  };

  postPatch = ''
    substituteInPlace src/app/translations.pri \
      --replace '$$[QT_INSTALL_BINS]/$$LRELEASE' '${lib.getDev libsForQt5.qttools}/bin/lrelease'
  '';

  nativeBuildInputs = [
    libsForQt5.qmake
    libsForQt5.qttools
    libsForQt5.wrapQtAppsHook
    installShellFiles
    autoPatchelfHook
  ];

  buildInputs = [
    libsForQt5.qtsvg
    libsForQt5.qtxmlpatterns
  ];

  qmakeFlags = [
    "-r"
    "PREFIX=${placeholder "out"}"
    "CONFIG+=noTests"
    "CONFIG+=noRunPath"
    "CONFIG+=no_ccache"
    "CONFIG+=noDebugSymbols"
  ];

  postInstall = ''
    installManPage dist/debian/*.1
    install -Dm644 dist/debian/valentina.sharedmimeinfo $out/share/mime/packages/valentina.xml
  '';

  meta = {
    description = "Open source sewing pattern drafting software";
    homepage = "https://smart-pattern.com.ua/";
    changelog = "https://gitlab.com/smart-pattern/valentina/-/blob/v${version}/ChangeLog.txt";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    maintainers = [ ];
  };
}
