{
  lib,
  stdenv,
  fetchFromGitHub,
  python3,
  qmake,
  qtbase,
  qtdeclarative,
  qtquickcontrols ? null, # Qt6: merged into qtdeclarative
  qtsvg,
  ncurses,
}:

let
  withQt6 = lib.strings.versionAtLeast qtbase.version "6";
in
stdenv.mkDerivation rec {
  pname = "pyotherside";
  version = "1.6.2";

  src = fetchFromGitHub {
    owner = "thp";
    repo = "pyotherside";
    rev = version;
    sha256 = "sha256-2OYVULNW9EzssqodiVtL2EmhTSbefXpLkub3zFvNwNo=";
  };

  postPatch = ''
    substituteInPlace qtquicktests/run \
      --replace-fail \
        'exec ./qtquicktests' \
        'exec ./${
          if stdenv.hostPlatform.isDarwin then
            "qtquicktests.app/Contents/MacOS/qtquicktests"
          else
            "qtquicktests"
        }' \
      --replace-fail \
        '-plugins ../src' \
        '-plugins ../src -import $out/${qtbase.qtQmlPrefix} -import ${lib.getBin qtdeclarative}/${qtbase.qtQmlPrefix}'
  '';

  nativeBuildInputs = [ qmake ];
  buildInputs = [
    python3
    qtbase
    (if withQt6 then qtdeclarative else qtquickcontrols)
    qtsvg
    ncurses
  ];

  dontWrapQtApps = true;

  patches = [ ./qml-path.patch ];
  installTargets = [ "sub-src-install_subtargets" ];

  doCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;

  checkPhase = ''
    runHook preCheck

    export QT_QPA_PLATFORM=minimal
    export QT_PLUGIN_PATH=${lib.getBin qtbase}/${qtbase.qtPluginPrefix}
    ./tests/tests

    runHook postCheck
  '';

  doInstallCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;

  installCheckPhase = ''
    runHook preInstallCheck

    pushd qtquicktests
    ./run
    popd

    runHook postInstallCheck
  '';

  meta = {
    description = "Asynchronous Python 3 Bindings for Qt ${lib.versions.major qtbase.version}";
    homepage = "https://thp.io/2011/pyotherside/";
    license = lib.licenses.isc;
    maintainers = [ lib.maintainers.mic92 ];
    platforms = lib.platforms.unix ++ lib.platforms.windows;
  };
}
