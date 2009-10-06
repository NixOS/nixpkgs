{ stdenv, fetchurl, pkgconfig, glib, dbus, dbus_glib, expat, pam
, intltool, gettext, libxslt, docbook_xsl, ... }:

stdenv.mkDerivation rec {
  name = "policykit-0.9";
  
  src = fetchurl {
    url = http://hal.freedesktop.org/releases/PolicyKit-0.9.tar.gz;
    sha256 = "1dw05s4xqj67i3c13knzl04l8jap0kywzpav6fidpmqrximpq37l";
  };
  
  buildInputs =
    [ pkgconfig glib dbus.libs dbus_glib expat pam intltool
      gettext libxslt
    ];

  configureFlags = "--localstatedir=/var --sysconfdir=/etc";

  installFlags = "localstatedir=$(TMPDIR)/var sysconfdir=$(out)/etc"; # keep `make install' happy

  # Read policy files from /etc/PolicyKit/policy instead of
  # /usr/share/PolicyKit/policy.  Using PACKAGE_DATA_DIR is hacky, but
  # it works because it's only used in the C code for finding the
  # policy directory.
  NIX_CFLAGS_COMPILE = "-DPACKAGE_DATA_DIR=\"/etc\"";

  # Needed to build the manpages.
  XML_CATALOG_FILES = "${docbook_xsl}/xml/xsl/docbook/catalog.xml";
  
  meta = {
    homepage = http://www.freedesktop.org/wiki/Software/PolicyKit;
    description = "A toolkit for defining and handling the policy that allows unprivileged processes to speak to privileged processes";
  };
}
