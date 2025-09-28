{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  glib,
  libsoup_2_4,
  libxml2,
  gobject-introspection,
  gtk-doc,
  docbook-xsl-nons,
  docbook_xml_dtd_412,
  gnome,
}:

stdenv.mkDerivation rec {
  pname = "rest";
  version = "0.8.1";

  outputs = [
    "out"
    "dev"
    "devdoc"
  ];

  src = fetchurl {
    url = "mirror://gnome/sources/rest/${lib.versions.majorMinor version}/rest-${version}.tar.xz";
    sha256 = "0513aad38e5d3cedd4ae3c551634e3be1b9baaa79775e53b2dba9456f15b01c9";
  };

  nativeBuildInputs = [
    pkg-config
    gobject-introspection
  ]
  ++ lib.optionals (stdenv.buildPlatform.canExecute stdenv.hostPlatform) [
    gtk-doc
    docbook-xsl-nons
    docbook_xml_dtd_412
  ];

  propagatedBuildInputs = [
    glib
    libsoup_2_4
    libxml2
  ];

  strictDeps = true;

  configureFlags = [
    (lib.enableFeature (stdenv.buildPlatform.canExecute stdenv.hostPlatform) "gtk-doc")
    # Remove when https://gitlab.gnome.org/GNOME/librest/merge_requests/2 is merged.
    "--with-ca-certificates=/etc/ssl/certs/ca-certificates.crt"
  ];

  postPatch = ''
    # pkg-config doesn't look in $PATH if strictDeps is on
    substituteInPlace ./configure \
      --replace-fail 'have_gtk_doc=no' "echo gtk-doc is present"
  '';

  passthru = {
    updateScript = gnome.updateScript {
      packageName = "rest";
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
    teams = [ teams.gnome ];
  };
}
