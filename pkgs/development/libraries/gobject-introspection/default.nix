{ stdenv
, lib
, fetchurl
, glib
, flex
, bison
, meson
, ninja
, gtk-doc
, docbook-xsl-nons
, docbook_xml_dtd_43
, docbook_xml_dtd_45
, pkg-config
, libffi
, python3
, cctools
, cairo
, gnome
, substituteAll
, buildPackages
, gobject-introspection-unwrapped
, nixStoreDir ? builtins.storeDir
, x11Support ? true
, testers
}:

# now that gobject-introspection creates large .gir files (eg gtk3 case)
# it may be worth thinking about using multiple derivation outputs
# In that case its about 6MB which could be separated

let
  pythonModules = pp: [
    pp.mako
    pp.markdown
  ];
in
stdenv.mkDerivation (finalAttrs: {
  pname = "gobject-introspection";
  version = "1.78.1";

  # outputs TODO: share/gobject-introspection-1.0/tests is needed during build
  # by pygobject3 (and maybe others), but it's only searched in $out
  outputs = [ "out" "dev" "devdoc" "man" ];
  outputBin = "dev";

  src = fetchurl {
    url = "mirror://gnome/sources/gobject-introspection/${lib.versions.majorMinor finalAttrs.version}/gobject-introspection-${finalAttrs.version}.tar.xz";
    sha256 = "vXur2Zr3JY52gZ5Fukprw5lgj+di2D/ePKwDPFCEG7Q=";
  };

  patches = [
    # Make g-ir-scanner put absolute path to GIR files it generates
    # so that programs can just dlopen them without having to muck
    # with LD_LIBRARY_PATH environment variable.
    (substituteAll {
      src = ./absolute_shlib_path.patch;
      inherit nixStoreDir;
    })
  ] ++ lib.optionals x11Support [
    # Hardcode the cairo shared library path in the Cairo gir shipped with this package.
    # https://github.com/NixOS/nixpkgs/issues/34080
    (substituteAll {
      src = ./absolute_gir_path.patch;
      cairoLib = "${lib.getLib cairo}/lib";
    })
  ];

  strictDeps = true;

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    flex
    bison
    gtk-doc
    docbook-xsl-nons
    docbook_xml_dtd_45
    # Build definition checks for the Python modules needed at runtime by importing them.
    (buildPackages.python3.withPackages pythonModules)
    finalAttrs.setupHook # move .gir files
    # can't use canExecute, we need prebuilt when cross
  ] ++ lib.optionals (stdenv.buildPlatform != stdenv.hostPlatform) [ gobject-introspection-unwrapped ];

  buildInputs = [
    (python3.withPackages pythonModules)
  ];

  nativeCheckInputs = lib.optionals stdenv.isDarwin [
    cctools # for otool
  ];

  propagatedBuildInputs = [
    libffi
    glib
  ];

  mesonFlags = [
    "--datadir=${placeholder "dev"}/share"
    "-Dcairo=disabled"
    "-Dgtk_doc=${lib.boolToString (stdenv.hostPlatform == stdenv.buildPlatform)}"
  ] ++ lib.optionals (!stdenv.buildPlatform.canExecute stdenv.hostPlatform) [
    "-Dgi_cross_ldd_wrapper=${substituteAll {
      name = "g-ir-scanner-lddwrapper";
      isExecutable = true;
      src = ./wrappers/g-ir-scanner-lddwrapper.sh;
      inherit (buildPackages) bash;
      buildlddtree = "${buildPackages.pax-utils}/bin/lddtree";
    }}"
    "-Dgi_cross_binary_wrapper=${stdenv.hostPlatform.emulator buildPackages}"
    # can't use canExecute, we need prebuilt when cross
  ] ++ lib.optionals (stdenv.buildPlatform != stdenv.hostPlatform) [
    "-Dgi_cross_use_prebuilt_gi=true"
  ];

  doCheck = !stdenv.isAarch64;

  # During configurePhase, two python scripts are generated and need this. See
  # https://github.com/NixOS/nixpkgs/pull/98316#issuecomment-695785692
  postConfigure = ''
    patchShebangs tools/*
  '';

  postInstall = lib.optionalString (stdenv.hostPlatform != stdenv.buildPlatform) ''
    cp -r ${buildPackages.gobject-introspection-unwrapped.devdoc} $devdoc
    # these are uncompiled c and header files which aren't installed when cross-compiling because
    # code that installs them is in tests/meson.build which is only run when not cross-compiling
    # pygobject3 needs them
    cp -r ${buildPackages.gobject-introspection-unwrapped.dev}/share/gobject-introspection-1.0/tests $dev/share/gobject-introspection-1.0/tests
  '';

  preCheck = ''
    # Our gobject-introspection patches make the shared library paths absolute
    # in the GIR files. When running tests, the library is not yet installed,
    # though, so we need to replace the absolute path with a local one during build.
    # We are using a symlink that we will delete before installation.
    mkdir -p $out/lib
    ln -s $PWD/tests/scanner/libregress-1.0${stdenv.targetPlatform.extensions.sharedLibrary} $out/lib/libregress-1.0${stdenv.targetPlatform.extensions.sharedLibrary}
  '';

  postCheck = ''
    rm $out/lib/libregress-1.0${stdenv.targetPlatform.extensions.sharedLibrary}
  '';

  setupHook = ./setup-hook.sh;

  passthru = {
    updateScript = gnome.updateScript {
      packageName = "gobject-introspection";
      versionPolicy = "odd-unstable";
    };
    tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
  };

  meta = with lib; {
    description = "A middleware layer between C libraries and language bindings";
    homepage = "https://gi.readthedocs.io/";
    maintainers = teams.gnome.members ++ (with maintainers; [ lovek323 artturin ]);
    pkgConfigModules = [ "gobject-introspection-1.0" ];
    platforms = platforms.unix;
    badPlatforms = [ lib.systems.inspect.platformPatterns.isStatic ];
    license = with licenses; [ gpl2 lgpl2 ];

    longDescription = ''
      GObject introspection is a middleware layer between C libraries (using
      GObject) and language bindings. The C library can be scanned at compile
      time and generate a metadata file, in addition to the actual native C
      library. Then at runtime, language bindings can read this metadata and
      automatically provide bindings to call into the C library.
    '';
  };
})
