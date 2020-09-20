{ stdenv
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
, gnome3
, substituteAll
, nixStoreDir ? builtins.storeDir
, x11Support ? true
}:

# now that gobject-introspection creates large .gir files (eg gtk3 case)
# it may be worth thinking about using multiple derivation outputs
# In that case its about 6MB which could be separated

stdenv.mkDerivation rec {
  pname = "gobject-introspection";
  version = "1.66.0";

  # outputs TODO: share/gobject-introspection-1.0/tests is needed during build
  # by pygobject3 (and maybe others), but it's only searched in $out
  outputs = [ "out" "dev" "devdoc" "man" ];
  outputBin = "dev";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "0q00llz0p7qik19a9fxq4bf6mqqqivkv77fqhcgqygvwxhxflrix";
  };

  patches = [
    # Make g-ir-scanner put absolute path to GIR files it generates
    # so that programs can just dlopen them without having to muck
    # with LD_LIBRARY_PATH environment variable.
    (substituteAll {
      src = ./absolute_shlib_path.patch;
      inherit nixStoreDir;
    })
  ] ++ stdenv.lib.optionals x11Support [
    # Hardcode the cairo shared library path in the Cairo gir shipped with this package.
    # https://github.com/NixOS/nixpkgs/issues/34080
    (substituteAll {
      src = ./absolute_gir_path.patch;
      cairoLib = "${stdenv.lib.getLib cairo}/lib";
    })
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    flex
    bison
    gtk-doc
    docbook-xsl-nons
    docbook_xml_dtd_45
    python3
    setupHook # move .gir files
  ];

  buildInputs = [
    python3
  ];

  checkInputs = stdenv.lib.optionals stdenv.isDarwin [
    cctools # for otool
  ];

  propagatedBuildInputs = [
    libffi
    glib
  ];

  mesonFlags = [
    "--datadir=${placeholder "dev"}/share"
    "-Ddoctool=disabled"
    "-Dcairo=disabled"
    "-Dgtk_doc=true"
  ];

  doCheck = !stdenv.isAarch64;

  # During configurePhase, two python scripts are generated and need this. See
  # https://github.com/NixOS/nixpkgs/pull/98316#issuecomment-695785692
  postConfigure = ''
    patchShebangs tools/*
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
    updateScript = gnome3.updateScript {
      packageName = pname;
    };
  };

  meta = with stdenv.lib; {
    description = "A middleware layer between C libraries and language bindings";
    homepage = "https://gi.readthedocs.io/";
    maintainers = teams.gnome.members ++ (with maintainers; [ lovek323 ]);
    platforms = platforms.unix;
    license = with licenses; [ gpl2 lgpl2 ];

    longDescription = ''
      GObject introspection is a middleware layer between C libraries (using
      GObject) and language bindings. The C library can be scanned at compile
      time and generate a metadata file, in addition to the actual native C
      library. Then at runtime, language bindings can read this metadata and
      automatically provide bindings to call into the C library.
    '';
  };
}
