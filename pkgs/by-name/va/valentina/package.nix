{
  lib,
  stdenv,
  libGL,
  xercesc,
  fetchFromGitLab,
  qbs,
  qt6,
}:

let
  qtEnv = qt6.env "valentina-qt-env" (
    with qt6;
    [
      qtsvg
      qttools
    ]
  );
in

stdenv.mkDerivation (finalAttrs: {
  pname = "valentina";
  version = "1.0.1";

  src = fetchFromGitLab {
    owner = "smart-pattern";
    repo = "valentina";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ob7dYqulC3xqtB3L38T6N0DsnDep53sIThBW7ZLpDeE=";
  };

  postPatch = ''
    mkdir -p qbs/modules/xerces-c
    cat > qbs/modules/xerces-c/xerces-c.qbs << EOF
    Module {
        Depends { name: "cpp" }
        cpp.includePaths: ["${xercesc}/include"]
        cpp.libraryPaths: ["${xercesc}/lib"]
        cpp.dynamicLibraries: ["xerces-c"]
    }
    EOF
  '';

  enableParallelBuilding = true;

  nativeBuildInputs = [
    qbs
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    qtEnv
    qt6.qtbase
    libGL
    xercesc
  ];

  strictDeps = true;

  configurePhase = ''
    runHook preConfigure

    qbs setup-qt --settings-dir . ${qtEnv}/bin/qmake qtenv
    qbs config --settings-dir . defaultProfile qtenv
    qbs resolve --file valentina.qbs --settings-dir . config:release qbs.installPrefix:/ \
      modules.buildconfig.enableUnitTests:false modules.buildconfig.enableCcache:false \
      modules.buildconfig.enableRPath:false modules.buildconfig.treatWarningsAsErrors:false

    runHook postConfigure
  '';

  buildPhase = ''
    runHook preBuild

    qbs build --file valentina.qbs --settings-dir . config:release -j $NIX_BUILD_CORES

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    qbs install --file valentina.qbs --settings-dir . --install-root $out config:release

    runHook postInstall
  '';

  meta = {
    description = "Open source sewing pattern drafting software";
    homepage = "https://smart-pattern.com.ua/";
    changelog = "https://gitlab.com/smart-pattern/valentina/-/blob/v${finalAttrs.version}/ChangeLog.txt";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    maintainers = [ ];
  };
})
