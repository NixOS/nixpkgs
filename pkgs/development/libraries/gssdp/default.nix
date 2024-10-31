{ stdenv
, lib
, fetchurl
, meson
, ninja
, pkg-config
, gobject-introspection
, vala
, gi-docgen
, python3
, libsoup
, glib
, gnome
, gssdp-tools
}:

stdenv.mkDerivation rec {
  pname = "gssdp";
  version = "1.4.1";

  outputs = [ "out" "dev" ]
    ++ lib.optionals (stdenv.buildPlatform == stdenv.hostPlatform) [ "devdoc" ];

  src = fetchurl {
    url = "mirror://gnome/sources/gssdp/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "VySWVDV9PVGxQDFRaaJMBnHeeqUsb3XIxcmr1Ao1JSk=";
  };

  strictDeps = true;

  depsBuildBuild = [
    pkg-config
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    gobject-introspection
    vala
    gi-docgen
    python3
  ];

  buildInputs = [
    libsoup
  ];

  propagatedBuildInputs = [
    glib
  ];

  mesonFlags = [
    "-Dgtk_doc=${lib.boolToString (stdenv.buildPlatform == stdenv.hostPlatform)}"
    "-Dsniffer=false"
  ];

  # Bail out! GLib-GIO-FATAL-CRITICAL: g_inet_address_to_string: assertion 'G_IS_INET_ADDRESS (address)' failed
  doCheck = !stdenv.hostPlatform.isDarwin;

  postFixup = lib.optionalString (stdenv.buildPlatform == stdenv.hostPlatform) ''
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
