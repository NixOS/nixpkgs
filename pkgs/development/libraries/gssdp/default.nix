{
  stdenv,
  lib,
  fetchpatch2,
  fetchurl,
  meson,
  ninja,
  pkg-config,
  gobject-introspection,
  vala,
  gi-docgen,
  python3,
  libsoup,
  glib,
  gnome,
  gssdp-tools,
  buildPackages,
  withIntrospection ?
    lib.meta.availableOn stdenv.hostPlatform gobject-introspection
    && stdenv.hostPlatform.emulatorAvailable buildPackages,
}:

stdenv.mkDerivation rec {
  pname = "gssdp";
  version = "1.4.1";

  outputs = [
    "out"
    "dev"
  ] ++ lib.optionals withIntrospection [ "devdoc" ];

  src = fetchurl {
    url = "mirror://gnome/sources/gssdp/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "VySWVDV9PVGxQDFRaaJMBnHeeqUsb3XIxcmr1Ao1JSk=";
  };

  patches = [
    (fetchpatch2 {
      # https://gitlab.gnome.org/GNOME/gssdp/-/merge_requests/11
      url = "https://gitlab.gnome.org/GNOME/gssdp/-/commit/db9d02c22005be7e5e81b43a3ab777250bd7b27b.diff";
      hash = "sha256-DJQrg6MhzpX8R0QaNnqdwA1+v8xncDU8jcX+I3scW1M=";
    })
  ];

  strictDeps = true;

  depsBuildBuild = [
    pkg-config
  ];

  nativeBuildInputs =
    [
      meson
      ninja
      pkg-config
      glib
      python3
    ]
    ++ lib.optionals withIntrospection [
      gobject-introspection
      vala
      gi-docgen
    ];

  buildInputs = [
    libsoup
  ];

  propagatedBuildInputs = [
    glib
  ];

  mesonFlags = [
    "-Dsniffer=false"
    (lib.mesonBool "gtk_doc" withIntrospection)
    (lib.mesonBool "introspection" withIntrospection)
    (lib.mesonBool "vapi" withIntrospection)
  ];

  # Bail out! GLib-GIO-FATAL-CRITICAL: g_inet_address_to_string: assertion 'G_IS_INET_ADDRESS (address)' failed
  doCheck = !stdenv.hostPlatform.isDarwin;

  postFixup = lib.optionalString withIntrospection ''
    # Move developer documentation to devdoc output.
    # Cannot be in postInstall, otherwise _multioutDocs hook in preFixup will move right back.
    find -L "$out/share/doc" -type f -regex '.*\.devhelp2?' -print0 \
      | while IFS= read -r -d ''' file; do
        moveToOutput "$(dirname "''${file/"$out/"/}")" "$devdoc"
    done
  '';

  passthru = {
    updateScript = gnome.updateScript {
      packageName = pname;
      freeze = true;
    };

    tests = {
      inherit gssdp-tools;
    };
  };

  meta = with lib; {
    description = "GObject-based API for handling resource discovery and announcement over SSDP";
    homepage = "http://www.gupnp.org/";
    license = licenses.lgpl2Plus;
    maintainers = teams.gnome.members;
    platforms = platforms.all;
  };
}
