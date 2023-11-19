{ stdenv
, lib
, fetchFromGitLab
, fetchpatch
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
    "devdoc"
  ];

  patches = [
    # Improves install locations of demo & docs
    # Remove when https://gitlab.com/ubports/development/core/geonames/-/merge_requests/3 merged & in release
    (fetchpatch {
      name = "0001-geonames-Use-CMAKE_INSTALL_BINDIR-for-install.patch";
      url = "https://gitlab.com/OPNA2608/geonames/-/commit/3bca6d4d02843aed851a0a7480d5cd5ac02b4cda.patch";
      hash = "sha256-vwffuMKpIqymYaiGEvnNeVXLmnz5e4aBpg55fnNbjKs=";
    })
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
  ] ++ lib.optionals (!stdenv.buildPlatform.canExecute stdenv.hostPlatform) [
    # only for cross without native execute support because the canExecute "emulator" call has a format that I can't get CMake to accept
    "-DCMAKE_CROSSCOMPILING_EMULATOR=${stdenv.hostPlatform.emulator buildPackages}"
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
