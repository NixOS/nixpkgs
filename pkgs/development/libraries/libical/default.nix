{ lib
, stdenv
, fetchFromGitHub
, pkgsBuildBuild
, pkgsBuildHost
, cmake
, glib
, icu
, libxml2
, ninja
, perl
, pkg-config
, libical
, python3
, tzdata
, fixDarwinDylibNames
, withIntrospection ? stdenv.hostPlatform.emulatorAvailable pkgsBuildHost
, gobject-introspection
, vala
}:

stdenv.mkDerivation rec {
  pname = "libical";
  version = "3.0.18";

  outputs = [ "out" "dev" ]; # "devdoc" ];

  src = fetchFromGitHub {
    owner = "libical";
    repo = "libical";
    rev = "v${version}";
    sha256 = "sha256-32FNnCybXO67Vtg1LM6miJUaK+r0mlfjxgLQg1LD8Es=";
  };

  strictDeps = true;

  depsBuildBuild = lib.optionals (stdenv.hostPlatform != stdenv.buildPlatform) [
    # provides ical-glib-src-generator that runs during build
    libical
  ];

  nativeBuildInputs = [
    cmake
    ninja
    perl
    pkg-config
  ] ++ lib.optionals withIntrospection [
    gobject-introspection
    vala
    # Docs building fails:
    # https://github.com/NixOS/nixpkgs/pull/67204
    # previously with https://github.com/NixOS/nixpkgs/pull/61657#issuecomment-495579489
    # gtk-doc docbook_xsl docbook_xml_dtd_43 # for docs
  ] ++ lib.optionals stdenv.isDarwin [
    fixDarwinDylibNames
  ];
  nativeInstallCheckInputs = [
    # running libical-glib tests
    (python3.pythonOnBuildForHost.withPackages (pkgs: with pkgs; [
      pygobject3
    ]))
  ];

  buildInputs = [
    glib
    libxml2
    icu
  ];

  cmakeFlags = [
    "-DENABLE_GTK_DOC=False"
    "-DGOBJECT_INTROSPECTION=${if withIntrospection then "True" else "False"}"
    "-DICAL_GLIB_VAPI=${if withIntrospection then "True" else "False"}"
  ] ++ lib.optionals (stdenv.hostPlatform != stdenv.buildPlatform) [
    "-DIMPORT_ICAL_GLIB_SRC_GENERATOR=${lib.getDev pkgsBuildBuild.libical}/lib/cmake/LibIcal/IcalGlibSrcGenerator.cmake"
  ];

  patches = [
    # Will appear in 3.1.0
    # https://github.com/libical/libical/issues/350
    ./respect-env-tzdir.patch
  ];

  postPatch = ''
    # Fix typo in test env setup
    # https://github.com/libical/libical/commit/03c02ced21494413920744a400c638b0cb5d493f
    substituteInPlace src/test/libical-glib/CMakeLists.txt \
      --replace-fail "''${CMAKE_BINARY_DIR}/src/libical-glib;\$ENV{GI_TYPELIB_PATH}" "''${CMAKE_BINARY_DIR}/src/libical-glib:\$ENV{GI_TYPELIB_PATH}" \
      --replace-fail "''${LIBRARY_OUTPUT_PATH};\$ENV{LD_LIBRARY_PATH}" "''${LIBRARY_OUTPUT_PATH}:\$ENV{LD_LIBRARY_PATH}"
  '';

  # Using install check so we do not have to manually set
  # LD_LIBRARY_PATH and GI_TYPELIB_PATH variables
  # Musl does not support TZDIR.
  doInstallCheck = !stdenv.hostPlatform.isMusl;
  enableParallelChecking = false;
  preInstallCheck = if stdenv.isDarwin then ''
    for testexe in $(find ./src/test -maxdepth 1 -type f -executable); do
      for lib in $(cd lib && ls *.3.dylib); do
        install_name_tool -change $lib $out/lib/$lib $testexe
      done
    done
  '' else null;
  installCheckPhase = ''
    runHook preInstallCheck

    export TZDIR=${tzdata}/share/zoneinfo
    ctest --output-on-failure

    runHook postInstallCheck
  '';

  meta = with lib; {
    homepage = "https://github.com/libical/libical";
    description = "Open Source implementation of the iCalendar protocols";
    changelog = "https://github.com/libical/libical/raw/v${version}/ReleaseNotes.txt";
    license = licenses.mpl20;
    platforms = platforms.unix;
  };
}
