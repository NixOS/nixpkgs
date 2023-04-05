{ stdenv
, lib
, fetchurl
, meson
, ninja
, pkg-config
, gobject-introspection
, vala
, pandoc
, gi-docgen
, python3
, libsoup_3
, glib
, gnome
, gssdp-tools
}:

stdenv.mkDerivation rec {
  pname = "gssdp";
  version = "1.6.2";

  outputs = [ "out" "dev" ]
    ++ lib.optionals (stdenv.buildPlatform == stdenv.hostPlatform) [ "devdoc" ];

  src = fetchurl {
    url = "mirror://gnome/sources/gssdp/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "QQs3be7O2YNrV/SI+ABS/koU+J4HWxzszyjlH0kPn7k=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    gobject-introspection
    vala
    pandoc
    gi-docgen
    python3
  ];

  buildInputs = [
    libsoup_3
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
      attrPath = "gssdp_1_6";
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
