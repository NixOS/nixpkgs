{
  stdenv,
  lib,
  fetchFromGitLab,
  gitUpdater,
  testers,
  buildPackages,
  cmake,
  docbook-xsl-nons,
  docbook_xml_dtd_45,
  gettext,
  glib,
  glibcLocales,
  withExamples ? true,
  gtk3,
  # Uses gtkdoc-scan* tools, which produces a binary linked against lib for hostPlatform and executes it to generate docs
  withDocumentation ? stdenv.buildPlatform.canExecute stdenv.hostPlatform,
  gtk-doc,
  pkg-config,
  validatePkgConfig,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "geonames";
  version = "0.3.1";

  src = fetchFromGitLab {
    owner = "ubports";
    repo = "development/core/geonames";
    rev = finalAttrs.version;
    hash = "sha256-AhRnUoku17kVY0UciHQXFDa6eCH6HQ4ZGIOobCaGTKQ=";
  };

  outputs = [
    "out"
    "dev"
  ]
  ++ lib.optionals withExamples [
    "bin"
  ]
  ++ lib.optionals withDocumentation [
    "devdoc"
  ];

  postPatch = ''
    patchShebangs src/generate-locales.sh tests/setup-test-env.sh
  '';

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    gettext
    glib # glib-compile-resources
    pkg-config
    validatePkgConfig
  ]
  ++ lib.optionals withDocumentation [
    docbook-xsl-nons
    docbook_xml_dtd_45
    gtk-doc
  ];

  buildInputs = [
    glib
  ]
  ++ lib.optionals withExamples [
    gtk3
  ];

  # Tests need to be able to check locale
  LC_ALL = lib.optionalString finalAttrs.finalPackage.doCheck "en_US.UTF-8";
  nativeCheckInputs = [
    glibcLocales
  ];

  makeFlags = [
    # gtkdoc-scan runs ld, can't find qsort & strncpy symbols
    "LD=${stdenv.cc.targetPrefix}cc"
  ];

  cmakeFlags = [
    (lib.cmakeBool "WANT_DOC" withDocumentation)
    (lib.cmakeBool "WANT_DEMO" withExamples)
    (lib.cmakeBool "WANT_TESTS" finalAttrs.finalPackage.doCheck)
    # Keeps finding & using glib-compile-resources from buildInputs otherwise
    (lib.cmakeFeature "CMAKE_PROGRAM_PATH" (lib.makeBinPath [ buildPackages.glib.dev ]))
  ]
  ++ lib.optionals (!stdenv.buildPlatform.canExecute stdenv.hostPlatform) [
    # only for cross without native execute support because the canExecute "emulator" call has a format that I can't get CMake to accept
    (lib.cmakeFeature "CMAKE_CROSSCOMPILING_EMULATOR" (stdenv.hostPlatform.emulator buildPackages))
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
    mainProgram = "geonames-demo";
    homepage = "https://gitlab.com/ubports/development/core/geonames";
    changelog = "https://gitlab.com/ubports/development/core/geonames/-/blob/${finalAttrs.version}/ChangeLog";
    license = licenses.gpl3Only;
    teams = [ teams.lomiri ];
    platforms = platforms.all;
    # Cross requires hostPlatform emulation during build
    # https://gitlab.com/ubports/development/core/geonames/-/issues/1
    broken =
      stdenv.buildPlatform != stdenv.hostPlatform && !stdenv.hostPlatform.emulatorAvailable buildPackages;
    pkgConfigModules = [
      "geonames"
    ];
  };
})
