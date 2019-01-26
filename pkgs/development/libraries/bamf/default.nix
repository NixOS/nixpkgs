{ stdenv, autoconf, automake, libtool, gnome3, which, fetchgit, libgtop, libwnck3, glib, vala, pkgconfig
, libstartup_notification, gobject-introspection, gtk-doc, docbook_xsl
, xorgserver, dbus, python2 }:

stdenv.mkDerivation rec {
  name = "bamf-${version}";
  version = "0.5.4";

  outputs = [ "out" "dev" "devdoc" ];

  src = fetchgit {
    url = https://git.launchpad.net/~unity-team/bamf;
    rev = version;
    sha256 = "1klvij1wyhdj5d8sr3b16pfixc1yk8ihglpjykg7zrr1f50jfgsz";
  };

  nativeBuildInputs = [
    autoconf
    automake
    docbook_xsl
    gnome3.gnome-common
    gobject-introspection
    gtk-doc
    libtool
    pkgconfig
    vala
    which
    # Tests
    python2
    python2.pkgs.libxslt
    python2.pkgs.libxml2
    dbus
    xorgserver
  ];

  buildInputs = [
    glib
    libgtop
    libstartup_notification
    libwnck3
  ];

  # Fix hard-coded path
  # https://bugs.launchpad.net/bamf/+bug/1780557
  postPatch = ''
    substituteInPlace data/Makefile.am \
      --replace '/usr/lib/systemd/user' '@prefix@/lib/systemd/user'
  '';

  configureFlags = [
    "--enable-headless-tests"
    "--enable-gtk-doc"
  ];

  # fix paths
  makeFlags = [
    "INTROSPECTION_GIRDIR=${placeholder ''dev''}/share/gir-1.0/"
    "INTROSPECTION_TYPELIBDIR=${placeholder ''out''}/lib/girepository-1.0"
  ];

  preConfigure = ''
    ./autogen.sh
  '';

  # TODO: Requires /etc/machine-id
  doCheck = false;

  # ignore deprecation errors
  NIX_CFLAGS_COMPILE = "-Wno-deprecated-declarations";

  meta = with stdenv.lib; {
    description = "Application matching framework";
    longDescription = ''
      Removes the headache of applications matching
      into a simple DBus daemon and c wrapper library.
    '';
    homepage = https://launchpad.net/bamf;
    license = licenses.lgpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ davidak ];
  };
}
