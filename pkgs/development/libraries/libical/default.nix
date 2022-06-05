{ lib
, stdenv
, fetchFromGitHub
, buildPackages
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
, withIntrospection ? stdenv.buildPlatform == stdenv.hostPlatform
, gobject-introspection
, vala
}:

stdenv.mkDerivation rec {
  pname = "libical";
  version = "3.0.14";

  outputs = [ "out" "dev" ]; # "devdoc" ];

  src = fetchFromGitHub {
    owner = "libical";
    repo = "libical";
    rev = "v${version}";
    sha256 = "sha256-gZ6IBjG5pNKJ+hWcTzXMP7yxL4he4LTklZGoC9vXra8=";
  };

  strictDeps = true;
  nativeBuildInputs = [
    cmake
    ninja
    perl
    pkg-config
    # Docs building fails:
    # https://github.com/NixOS/nixpkgs/pull/67204
    # previously with https://github.com/NixOS/nixpkgs/pull/61657#issuecomment-495579489
    # gtk-doc docbook_xsl docbook_xml_dtd_43 # for docs
  ] ++ lib.optionals (stdenv.hostPlatform != stdenv.buildPlatform) [
    # provides ical-glib-src-generator that runs during build
    libical
  ] ++ lib.optionals withIntrospection [
    gobject-introspection
    vala
  ] ++ lib.optionals stdenv.isDarwin [
    fixDarwinDylibNames
  ];
  installCheckInputs = [
    # running libical-glib tests
    (python3.withPackages (pkgs: with pkgs; [
      pygobject3
    ]))
  ];

  buildInputs = [
    glib
    libxml2
    icu
  ] ++ lib.optionals withIntrospection [
    gobject-introspection
  ];

  cmakeFlags = [
    "-DENABLE_GTK_DOC=False"
    "-DGOBJECT_INTROSPECTION=${if withIntrospection then "True" else "False"}"
    "-DICAL_GLIB_VAPI=${if withIntrospection then "True" else "False"}"
  ] ++ lib.optionals (stdenv.hostPlatform != stdenv.buildPlatform) [
    "-DIMPORT_ICAL_GLIB_SRC_GENERATOR=${lib.getDev buildPackages.libical}/lib/cmake/LibIcal/IcalGlibSrcGenerator.cmake"
  ];

  patches = [
    # Will appear in 3.1.0
    # https://github.com/libical/libical/issues/350
    ./respect-env-tzdir.patch
  ];

  # Using install check so we do not have to manually set
  # LD_LIBRARY_PATH and GI_TYPELIB_PATH variables
  doInstallCheck = true;
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
    broken = stdenv.isDarwin;
    homepage = "https://github.com/libical/libical";
    description = "An Open Source implementation of the iCalendar protocols";
    license = licenses.mpl20;
    platforms = platforms.unix;
  };
}
