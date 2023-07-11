{ stdenv
, lib
, fetchFromGitLab
, gitUpdater
, testers
, buildPackages
, cmake
, docbook-xsl-nons
, docbook_xml_dtd_45
, gettext
, glib
, glibcLocales
, withExamples ? true
, gtk3
# Uses gtkdoc-scan* tools, which produces a binary linked against lib for hostPlatform and executes it to generate docs
, withDocumentation ? stdenv.buildPlatform.canExecute stdenv.hostPlatform
, gtk-doc
, pkg-config
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "geonames";
  version = "0.3.0";

  src = fetchFromGitLab {
    owner = "ubports";
    repo = "development/core/geonames";
    rev = finalAttrs.version;
    hash = "sha256-Mo7Khj2pgdJ9kT3npFXnh1WTSsY/B1egWTccbAXFNY8=";
  };

  outputs = [
    "out"
    "dev"
  ] ++ lib.optionals withExamples [
    "bin"
  ] ++ lib.optionals withDocumentation [
    "doc"
  ];

  postPatch = ''
    patchShebangs src/generate-locales.sh tests/setup-test-env.sh

    substituteInPlace doc/reference/CMakeLists.txt \
      --replace "\''${CMAKE_INSTALL_DATADIR}/gtk-doc/html/\''${PROJECT_NAME}" "\''${CMAKE_INSTALL_DOCDIR}"
    substituteInPlace demo/CMakeLists.txt \
      --replace 'RUNTIME DESTINATION bin' 'RUNTIME DESTINATION ''${CMAKE_INSTALL_BINDIR}'
  '' + lib.optionalString (stdenv.buildPlatform != stdenv.hostPlatform) ''
    # Built for hostPlatform, executed during build
    substituteInPlace src/CMakeLists.txt \
      --replace 'COMMAND mkdb' 'COMMAND ${stdenv.hostPlatform.emulator buildPackages} mkdb'
  '';

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    gettext
    glib # glib-compile-resources
    pkg-config
  ] ++ lib.optionals withDocumentation [
    docbook-xsl-nons
    docbook_xml_dtd_45
    gtk-doc
  ];

  buildInputs = [
    glib
  ] ++ lib.optionals withExamples [
    gtk3
  ];

  # Tests need to be able to check locale
  LC_ALL = lib.optionalString finalAttrs.doCheck "en_US.UTF-8";
  nativeCheckInputs = [
    glibcLocales
  ];

  makeFlags = [
    # gtkdoc-scan runs ld, can't find qsort & strncpy symbols
    "LD=${stdenv.cc.targetPrefix}cc"
  ];

  cmakeFlags = [
    "-DWANT_DOC=${lib.boolToString withDocumentation}"
    "-DWANT_DEMO=${lib.boolToString withExamples}"
    "-DWANT_TESTS=${lib.boolToString finalAttrs.doCheck}"
    # Keeps finding & using glib-compile-resources from buildInputs otherwise
    "-DCMAKE_PROGRAM_PATH=${lib.makeBinPath [ buildPackages.glib.dev ]}"
  ];

  preInstall = lib.optionalString withDocumentation ''
    # gtkdoc-mkhtml generates images without write permissions, errors out during install
    chmod +w doc/reference/html/*
  '';

  doCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;

  passthru = {
    tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    updateScript = gitUpdater { };
  };

  meta = with lib; {
    description = "Parse and query the geonames database dump";
    homepage = "https://gitlab.com/ubports/development/core/geonames";
    license = licenses.gpl3Only;
    maintainers = teams.lomiri.members;
    platforms = platforms.all;
    # Cross requires hostPlatform emulation during build
    # https://gitlab.com/ubports/development/core/geonames/-/issues/1
    broken = stdenv.buildPlatform != stdenv.hostPlatform && !stdenv.hostPlatform.emulatorAvailable buildPackages;
    pkgConfigModules = [
      "geonames"
    ];
  };
})
