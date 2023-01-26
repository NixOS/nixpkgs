{ stdenv
, lib
, docbook-xsl-nons
, fetchurl
, glib
, gobject-introspection
, gtk-doc
, libgudev
, libpcap
, meson
, mesonEmulatorHook
, ninja
, pkg-config
, python3
, systemd
, usbutils
, vala
, which
}:

stdenv.mkDerivation rec {
  pname = "umockdev";
  version = "0.17.15";

  outputs = [ "bin" "out" "dev" "devdoc" ];

  src = fetchurl {
    url = "https://github.com/martinpitt/umockdev/releases/download/${version}/${pname}-${version}.tar.xz";
    sha256 = "7UGO4rv7B4H0skuXKe8nCtg83czWaln/lEsFnvE2j+8=";
  };

  patches = [
    # Hardcode absolute paths to libraries so that consumers
    # do not need to set LD_LIBRARY_PATH themselves.
    ./hardcode-paths.patch
  ];

  nativeBuildInputs = [
    docbook-xsl-nons
    gobject-introspection
    gtk-doc
    meson
    ninja
    pkg-config
    vala
  ] ++ lib.optionals (!stdenv.buildPlatform.canExecute stdenv.hostPlatform) [
    mesonEmulatorHook
  ];

  buildInputs = [
    gobject-introspection
    glib
    systemd
    libgudev
    libpcap
  ];

  nativeCheckInputs = [
    python3
    which
    usbutils
  ];

  mesonFlags = [
    "-Dgtk_doc=true"
  ];

  doCheck = true;

  postPatch = ''
    # Substitute the path to this derivation in the patch we apply.
    substituteInPlace src/umockdev-wrapper \
      --subst-var-by 'LIBDIR' "''${!outputLib}/lib"
  '';

  preCheck = ''
    # Our patch makes the path to the `LD_PRELOAD`ed library absolute.
    # When running tests, the library is not yet installed, though,
    # so we need to replace the absolute path with a local one during build.
    # We are using a symlink that will be overridden during installation.
    mkdir -p "$out/lib"
    ln -s "$PWD/libumockdev-preload.so.0" "$out/lib/libumockdev-preload.so.0"
  '';

  meta = with lib; {
    homepage = "https://github.com/martinpitt/umockdev";
    changelog = "https://github.com/martinpitt/umockdev/releases/tag/${version}";
    description = "Mock hardware devices for creating unit tests";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ flokli ];
    platforms = with platforms; linux;
  };
}
