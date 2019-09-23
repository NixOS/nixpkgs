{ stdenv, fetchurl, meson, ninja, pkgconfig, gettext, vala, glib, liboauth, gtk3
, gtk-doc, docbook_xsl, docbook_xml_dtd_43, fetchpatch
, libxml2, gnome3, gobject-introspection, libsoup, totem-pl-parser }:

let
  pname = "grilo";
  version = "0.3.9"; # if you change minor, also change ./setup-hook.sh
in stdenv.mkDerivation rec {
  name = "${pname}-${version}";

  outputs = [ "out" "dev" "man" "devdoc" ];
  outputBin = "dev";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${name}.tar.xz";
    sha256 = "1wnabc69730jsv8dljj5ik8g7p581nw60mw1mkgamkzjcb6821bk";
  };

  setupHook = ./setup-hook.sh;

  mesonFlags = [
    "-Dgtk_doc=true"
  ];

  patches = [
    # https://gitlab.gnome.org/GNOME/grilo/merge_requests/45
    # commits are from a separate branch so they shouldn't 404
    (fetchpatch {
      url = "https://gitlab.gnome.org/worldofpeace/grilo/commit/f6993c2a8a6c1a6246372569f9f7a9179955c95e.patch";
      sha256 = "1x4s0ahs60dqyphgv2dy3x2sjnxv5ydd55kdlcjsys5870ijwbi8";
    })
    (fetchpatch {
      url = "https://gitlab.gnome.org/worldofpeace/grilo/commit/61bca28b141162a33eb2fb575ef1daf0f21c7741.patch";
      sha256 = "1147xbmaq61myfwxz0pagdv056krfmh1s78qjbiy5k7k203qrjz0";
    })
    (fetchpatch {
      url = "https://gitlab.gnome.org/worldofpeace/grilo/commit/363b198a062eeb8aaa5489ea9720e69d428e885c.patch";
      sha256 = "01w1bfzdbnxy5l37b2z7a9h2mrxziqkzdw02dybjphy85nb0hz5w";
    })
  ];

  nativeBuildInputs = [
    meson ninja pkgconfig gettext gobject-introspection vala
    gtk-doc docbook_xsl docbook_xml_dtd_43
  ];
  buildInputs = [ glib liboauth gtk3 libxml2 libsoup totem-pl-parser ];

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
      versionPolicy = "none";
    };
  };

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Projects/Grilo;
    description = "Framework that provides access to various sources of multimedia content, using a pluggable system";
    maintainers = gnome3.maintainers;
    license = licenses.lgpl2;
    platforms = platforms.linux;
  };
}
