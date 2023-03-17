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
, gtk3
, libgee
, check
, gtk-doc
, docbook-xsl-nons
, docbook_xml_dtd_43
, gobject-introspection
, libsoup
}:

stdenv.mkDerivation rec {
  pname = "libdmapsharing";
  version = "3.9.10";

  outputs = [ "out" "dev" "devdoc" ];
  outputBin = "dev";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "GNOME";
    repo = pname;
    rev = "${lib.toUpper pname}_${lib.replaceStrings ["."] ["_"] version}";
    sha256 = "04y1wjwnbw4pzg05h383d83p6an6ylwy4b4g32jmjxpfi388x33g";
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
    libsoup
  ];

  nativeCheckInputs = [
    libgee
    check
    gtk3
  ];

  configureFlags = [
    "--enable-gtk-doc"
  ];

  # Cannot disable tests here or `check` from nativeCheckInputs would not be included.
  # Cannot disable building the tests or docs will not build:
  # https://gitlab.gnome.org/GNOME/libdmapsharing/-/issues/49
  doCheck = true;

  preConfigure = ''
    NOCONFIGURE=1 ./autogen.sh
  '';

  # Tests require mDNS server.
  checkPhase = ":";

  meta = with lib; {
    homepage = "https://www.flyn.org/projects/libdmapsharing/";
    description = "Library that implements the DMAP family of protocols";
    maintainers = teams.gnome.members;
    license = licenses.lgpl21Plus;
    platforms = platforms.linux;
  };
}
