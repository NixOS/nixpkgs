{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,
  pkg-config,
  vala,
  gobject-introspection,
  gtk-doc,
  docbook_xsl,
  docbook_xml_dtd_412,
  glib,
  libxml2,
  libsoup,
  gnome,
  buildPackages,
  Foundation,
  AppKit,
}:

stdenv.mkDerivation rec {
  pname = "libgrss";
  version = "0.7.0";

  outputs = [
    "out"
    "dev"
    "devdoc"
  ];

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "1nalslgyglvhpva3px06fj6lv5zgfg0qmj0sbxyyl5d963vc02b7";
  };

  patches = [
    (fetchpatch {
      name = "CVE-2016-20011.patch";
      # https://gitlab.gnome.org/GNOME/libgrss/-/merge_requests/7, not yet merged!
      url = "https://gitlab.gnome.org/GNOME/libgrss/-/commit/2c6ea642663e2a44efc8583fae7c54b7b98f72b3.patch";
      sha256 = "1ijvq2jl97vphcvrbrqxvszdmv6yyjfygdca9vyaijpafwyzzb18";
    })
  ];

  nativeBuildInputs = [
    pkg-config
    vala
    gobject-introspection
    gtk-doc
    docbook_xsl
    docbook_xml_dtd_412
  ];

  buildInputs =
    [
      glib
      libxml2
      libsoup
    ]
    ++ lib.optionals stdenv.isDarwin [
      Foundation
      AppKit
    ];

  configureFlags =
    [
      "PKG_CONFIG=${buildPackages.pkg-config}/bin/${buildPackages.pkg-config.targetPrefix}pkg-config"
    ]
    ++ lib.optionals (stdenv.buildPlatform == stdenv.hostPlatform) [
      "--enable-gtk-doc"
    ];

  doCheck = true;

  passthru = {
    updateScript = gnome.updateScript {
      packageName = pname;
      versionPolicy = "none";
    };
  };

  meta = with lib; {
    description = "Glib abstaction to handle feeds in RSS, Atom and other formats";
    homepage = "https://gitlab.gnome.org/GNOME/libgrss";
    license = licenses.lgpl3Plus;
    maintainers = teams.gnome.members;
    platforms = platforms.unix;
  };
}
