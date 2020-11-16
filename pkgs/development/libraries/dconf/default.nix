{ stdenv
, fetchurl
, meson
, ninja
, python3
, vala
, libxslt
, pkg-config
, glib
, bash-completion
, dbus
, gnome3
, libxml2
, gtk-doc
, docbook-xsl-nons
, docbook_xml_dtd_42
}:

stdenv.mkDerivation rec {
  pname = "dconf";
  version = "0.38.0";

  outputs = [ "out" "lib" "dev" "devdoc" ];

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "0n2gqkp6d61h7gnnp2xnxp6w5wcl7w9ay58krrf729qd6d0hzxj5";
  };

  nativeBuildInputs = [
    meson
    ninja
    vala
    pkg-config
    python3
    libxslt
    libxml2
    glib
    gtk-doc
    docbook-xsl-nons
    docbook_xml_dtd_42
  ];

  buildInputs = [
    glib
    bash-completion
    dbus
  ];

  mesonFlags = [
    "--sysconfdir=/etc"
    "-Dgtk_doc=true"
  ];

  doCheck = !stdenv.isAarch32 && !stdenv.isAarch64 && !stdenv.isDarwin;

  postPatch = ''
    chmod +x meson_post_install.py tests/test-dconf.py
    patchShebangs meson_post_install.py
    patchShebangs tests/test-dconf.py
  '';

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
    };
  };

  meta = with stdenv.lib; {
    homepage = "https://wiki.gnome.org/Projects/dconf";
    license = licenses.lgpl21Plus;
    platforms = platforms.unix;
    maintainers = teams.gnome.members;
  };
}
