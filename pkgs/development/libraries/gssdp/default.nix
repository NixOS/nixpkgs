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
  version = "1.4.0.1";

  outputs = [ "out" "dev" ]
    ++ lib.optionals (stdenv.buildPlatform == stdenv.hostPlatform) [ "devdoc" ];

  src = fetchurl {
    url = "mirror://gnome/sources/gssdp/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "hnaEnVf7giuHKIVtut6/OGf4nuR6DsR6IARdAR9DFYI=";
  };

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
    "-Dintrospection=${lib.boolToString (stdenv.buildPlatform == stdenv.hostPlatform)}"
  ];

  doCheck = true;

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
    };

    tests = {
      inherit gssdp-tools;
    };
  };

  meta = with lib; {
    broken = stdenv.isDarwin;
    description = "GObject-based API for handling resource discovery and announcement over SSDP";
    homepage = "http://www.gupnp.org/";
    license = licenses.lgpl2Plus;
    maintainers = teams.gnome.members;
    platforms = platforms.all;
  };
}
