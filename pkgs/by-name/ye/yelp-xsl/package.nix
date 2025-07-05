{
  lib,
  stdenv,
  meson,
  ninja,
  gettext,
  fetchurl,
  pkg-config,
  itstool,
  libxml2,
  libxslt,
  gnome,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "yelp-xsl";
  version = "42.4";

  src = fetchurl {
    url = "mirror://gnome/sources/yelp-xsl/${lib.versions.major finalAttrs.version}/yelp-xsl-${finalAttrs.version}.tar.xz";
    hash = "sha256-/euwfrLman+3oNzmrYJIrSmku7E0uoKRKMoQT1ir19E=";
  };

  nativeBuildInputs = [
    pkg-config
    meson
    ninja
    gettext
    itstool
    libxml2
    libxslt
  ];

  doCheck = true;

  postPatch = ''
    patchShebangs \
      xslt/common/domains/gen_yelp_xml.sh
  '';

  passthru = {
    updateScript = gnome.updateScript {
      packageName = "yelp-xsl";
    };
  };

  meta = with lib; {
    homepage = "https://gitlab.gnome.org/GNOME/yelp-xsl";
    description = "Yelp's universal stylesheets for Mallard and DocBook";
    teams = [ teams.gnome ];
    license = with licenses; [
      # See https://gitlab.gnome.org/GNOME/yelp-xsl/blob/master/COPYING
      # Stylesheets
      lgpl2Plus
      # Icons, unclear: https://gitlab.gnome.org/GNOME/yelp-xsl/issues/25
      gpl2
      # highlight.js
      bsd3
    ];
    platforms = platforms.unix;
  };
})
