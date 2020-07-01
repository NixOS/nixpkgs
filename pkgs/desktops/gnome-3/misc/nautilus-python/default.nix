{ stdenv
, fetchurl
, pkgconfig
, which
, gtk-doc
, docbook_xsl
, docbook_xml_dtd_412
, python3
, ncurses
, nautilus
, gtk3
, gnome3
}:

stdenv.mkDerivation rec {
  pname = "nautilus-python";
  version = "1.2.3";

  outputs = [ "out" "dev" "doc" ];

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "161050sx3sdxqcpjkjcpf6wl4kx0jydihga7mcvrj9c2f8ly0g07";
  };

  nativeBuildInputs = [
    pkgconfig
    which
    gtk-doc
    docbook_xsl
    docbook_xml_dtd_412
  ];

  buildInputs = [
    python3
    ncurses # required by python3
    python3.pkgs.pygobject3
    nautilus
    gtk3 # required by libnautilus-extension
  ];

  makeFlags = [
    "PYTHON_LIB_LOC=${python3}/lib"
  ];

  PKG_CONFIG_LIBNAUTILUS_EXTENSION_EXTENSIONDIR = "${placeholder "out"}/lib/nautilus/extensions-3.0";

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
      attrPath = "gnome3.${pname}";
    };
  };

  meta = with stdenv.lib; {
    description = "Python bindings for the Nautilus Extension API";
    homepage = "https://wiki.gnome.org/Projects/NautilusPython";
    license = licenses.gpl2Plus;
    maintainers = teams.gnome.members;
    platforms = platforms.unix;
  };
}
