{ stdenv
, fetchFromGitLab
, pkgconfig
, meson
, ninja
, gusb
, pixman
, glib
, nss
, gobject-introspection
, coreutils
, gtk-doc
, docbook_xsl
, docbook_xml_dtd_43
}:

stdenv.mkDerivation rec {
  pname = "libfprint";
  version = "1.90.2";
  outputs = [ "out" "devdoc" ];

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "libfprint";
    repo = pname;
    rev = "v${version}";
    sha256 = "0g890y49anqd7yfz86iyvywxgbfmfmj6813fy58m5n8jain7iy1b";
  };

  nativeBuildInputs = [
    pkgconfig
    meson
    ninja
    gtk-doc
    docbook_xsl
    docbook_xml_dtd_43
    gobject-introspection
  ];

  buildInputs = [
    gusb
    pixman
    glib
    nss
  ];

  mesonFlags = [
    "-Dudev_rules_dir=${placeholder "out"}/lib/udev/rules.d"
  ];

  meta = with stdenv.lib; {
    homepage = "https://fprint.freedesktop.org/";
    description = "A library designed to make it easy to add support for consumer fingerprint readers";
    license = licenses.lgpl21;
    platforms = platforms.linux;
    maintainers = with maintainers; [ abbradar ];
  };
}
