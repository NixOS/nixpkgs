{ stdenv
, lib
, fetchFromGitLab
, autoconf
, automake
, libtool
, which
, pkg-config
, python3
, vala
, avahi
, gdk-pixbuf
, gst_all_1
, glib
, gtk-doc
, docbook-xsl-nons
, docbook_xml_dtd_43
, gobject-introspection
, libsoup_3
}:

stdenv.mkDerivation rec {
  pname = "libdmapsharing";
  version = "3.9.12";

  outputs = [ "out" "dev" "devdoc" ];
  outputBin = "dev";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "GNOME";
    repo = pname;
    rev = "${lib.toUpper pname}_${lib.replaceStrings ["."] ["_"] version}";
    sha256 = "tnQ25RR/bAZJKa8vTwzkGK1iPc7CMGFbyX8mBf6TKr4=";
  };

  nativeBuildInputs = [
    autoconf
    automake
    libtool
    which
    pkg-config
    python3
    gobject-introspection
    vala
    gtk-doc
    docbook-xsl-nons
    docbook_xml_dtd_43
  ];

  buildInputs = [
    avahi
    gdk-pixbuf
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
  ];

  propagatedBuildInputs = [
    glib
    libsoup_3
  ];

  configureFlags = [
    "--enable-gtk-doc"
    "--disable-tests" # Tests require mDNS server.
  ];

  preConfigure = ''
    NOCONFIGURE=1 ./autogen.sh
  '';

  meta = with lib; {
    homepage = "https://www.flyn.org/projects/libdmapsharing/";
    description = "Library that implements the DMAP family of protocols";
    maintainers = teams.gnome.members;
    license = licenses.lgpl21Plus;
    platforms = platforms.linux;
  };
}
