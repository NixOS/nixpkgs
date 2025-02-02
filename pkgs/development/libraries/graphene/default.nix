{ stdenv
, lib
, fetchFromGitHub
, fetchpatch
, nix-update-script
, pkg-config
, meson
, mesonEmulatorHook
, ninja
, python3
, mutest
, nixosTests
, glib
, withDocumentation ? !stdenv.hostPlatform.isStatic
, gtk-doc
, docbook_xsl
, docbook_xml_dtd_43
, buildPackages
, gobject-introspection
, withIntrospection ? lib.meta.availableOn stdenv.hostPlatform gobject-introspection && stdenv.hostPlatform.emulatorAvailable buildPackages
, makeWrapper
, testers
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "graphene";
  version = "1.10.8";

  outputs = [ "out" "dev" ]
    ++ lib.optionals withDocumentation [ "devdoc" ]
    ++ lib.optionals (stdenv.hostPlatform == stdenv.buildPlatform) [ "installedTests" ];

  src = fetchFromGitHub {
    owner = "ebassi";
    repo = finalAttrs.pname;
    rev = finalAttrs.version;
    sha256 = "P6JQhSktzvyMHatP/iojNGXPmcsxsFxdYerXzS23ojI=";
  };

  patches = [
    # Add option for changing installation path of installed tests.
    ./0001-meson-add-options-for-tests-installation-dirs.patch

    # Disable flaky simd_operators_reciprocal test
    # https://github.com/ebassi/graphene/issues/246
    (fetchpatch {
      url = "https://github.com/ebassi/graphene/commit/4fbdd07ea3bcd0964cca3966010bf71cb6fa8209.patch";
      sha256 = "uFkkH0u4HuQ/ua1mfO7sJZ7MPrQdV/JON7mTYB4DW80=";
      includes = [ "tests/simd.c" ];
      revert = true;
    })
  ];

  depsBuildBuild = [
    pkg-config
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    python3
    makeWrapper
  ] ++ lib.optionals withDocumentation [
    docbook_xml_dtd_43
    docbook_xsl
    gtk-doc
  ] ++ lib.optionals withIntrospection [
    gobject-introspection
  ] ++ lib.optionals (!stdenv.buildPlatform.canExecute stdenv.hostPlatform) [
    mesonEmulatorHook
  ];

  buildInputs = [
    glib
  ];

  nativeCheckInputs = [
    mutest
  ];

  mesonFlags = [
    (lib.mesonBool "gtk_doc" withDocumentation)
    (lib.mesonEnable "introspection" withIntrospection)
    "-Dinstalled_test_datadir=${placeholder "installedTests"}/share"
    "-Dinstalled_test_bindir=${placeholder "installedTests"}/libexec"
  ] ++ lib.optionals stdenv.isAarch32 [
    # the box test is failing with SIGBUS on armv7l-linux
    # https://github.com/ebassi/graphene/issues/215
    "-Darm_neon=false"
  ];

  doCheck = true;

  postPatch = ''
    patchShebangs tests/gen-installed-test.py
  '' + lib.optionalString withIntrospection ''
    PATH=${python3.withPackages (pp: [ pp.pygobject3 pp.tappy ])}/bin:$PATH patchShebangs tests/introspection.py
  '';

  postFixup = let
    introspectionPy = "${placeholder "installedTests"}/libexec/installed-tests/graphene-1.0/introspection.py";
  in lib.optionalString withIntrospection ''
    if [ -x '${introspectionPy}' ] ; then
      wrapProgram '${introspectionPy}' \
        --prefix GI_TYPELIB_PATH : "$out/lib/girepository-1.0"
    fi
  '';

  passthru = {
    tests = {
      installedTests = nixosTests.installed-tests.graphene;
      pkg-config = testers.hasPkgConfigModules {
        package = finalAttrs.finalPackage;
      };
    };

    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "Thin layer of graphic data types";
    homepage = "https://github.com/ebassi/graphene";
    license = licenses.mit;
    maintainers = teams.gnome.members ++ (with maintainers; [ ]);
    platforms = platforms.unix;
    pkgConfigModules = [ "graphene-1.0" "graphene-gobject-1.0" ];
  };
})
