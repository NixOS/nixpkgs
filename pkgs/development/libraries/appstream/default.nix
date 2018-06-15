{ stdenv, fetchpatch, fetchFromGitHub, meson, ninja, pkgconfig, gettext
, xmlto, docbook_xsl, docbook_xml_dtd_45, libxslt
, libstemmer, glib, xapian, libxml2, libyaml, gobjectIntrospection
, pcre, itstool
}:

stdenv.mkDerivation rec {
  name = "appstream-${version}";
  version = "0.11.8";

  src = fetchFromGitHub {
    owner  = "ximion";
    repo   = "appstream";
    rev    = "APPSTREAM_${stdenv.lib.replaceStrings ["."] ["_"] version}";
    sha256 = "07vzz57g1p5byj2jfg17y5n3il0g07d9wkiynzwra71mcxar1p08";
  };

  patches = [
    # drop this in version 0.11.9 and above
    (fetchpatch {
      name   = "define-location-and-soname.patch";
      url    = "https://github.com/ximion/appstream/commit/3e58f9c9.patch";
      sha256 = "1ffgbdfg80yq5vahjrvdd4f8xsp32ksm9vyasfmc7hzhx294s78w";
    })
  ];

  nativeBuildInputs = [
    meson ninja pkgconfig gettext
    libxslt xmlto docbook_xsl docbook_xml_dtd_45
    gobjectIntrospection itstool
  ];

  buildInputs = [ libstemmer pcre glib xapian libxml2 libyaml ];

  prePatch = ''
    substituteInPlace meson.build \
      --replace /usr/include ${libstemmer}/include

    substituteInPlace data/meson.build \
      --replace /etc $out/etc
  '';

  mesonFlags = [
    "-Dapidocs=false"
    "-Ddocs=false"
    "-Dgir=false"
  ];

  meta = with stdenv.lib; {
    description = "Software metadata handling library";
    homepage    = https://www.freedesktop.org/wiki/Distributions/AppStream/;
    longDescription = ''
      AppStream is a cross-distro effort for building Software-Center applications
      and enhancing metadata provided by software components.  It provides
      specifications for meta-information which is shipped by upstream projects and
      can be consumed by other software.
    '';
    license     = licenses.lgpl21Plus;
    platforms   = platforms.linux;
 };
}
