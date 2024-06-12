{ lib
, stdenv
, fetchurl
, pkg-config
, glib
, libsoup
, libxml2
, gobject-introspection
, gtk-doc
, docbook-xsl-nons
, docbook_xml_dtd_412
, gnome
}:

stdenv.mkDerivation rec {
  pname = "rest";
  version = "0.8.1";

  outputs = [ "out" "dev" "devdoc" ];

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "0513aad38e5d3cedd4ae3c551634e3be1b9baaa79775e53b2dba9456f15b01c9";
  };

  nativeBuildInputs = [
    pkg-config
    gobject-introspection
  ] ++ lib.optionals (stdenv.hostPlatform == stdenv.buildPlatform) [
    gtk-doc
    docbook-xsl-nons
    docbook_xml_dtd_412
  ];

  propagatedBuildInputs = [
    glib
    libsoup
    libxml2
  ];

  configureFlags = [
    (lib.enableFeature (stdenv.hostPlatform == stdenv.buildPlatform) "gtk-doc")
    # Remove when https://gitlab.gnome.org/GNOME/librest/merge_requests/2 is merged.
    "--with-ca-certificates=/etc/ssl/certs/ca-certificates.crt"
  ];

  passthru = {
    updateScript = gnome.updateScript {
      packageName = pname;
      attrPath = "librest";
      versionPolicy = "odd-unstable";
      freeze = true;
    };
  };

  meta = with lib; {
    description = "Helper library for RESTful services";
    homepage = "https://gitlab.gnome.org/GNOME/librest";
    license = licenses.lgpl21Only;
    platforms = platforms.unix;
    maintainers = teams.gnome.members;
  };
}
