{ stdenv
, pantheon
, autoconf
, automake
, libtool
, gnome3
, which
, fetchgit
, libgtop
, libwnck3
, glib
, vala
, pkgconfig
, libstartup_notification
, gobject-introspection
, gtk-doc
, docbook_xsl
, xorgserver
, dbus
, python3
, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  pname = "bamf";
  version = "0.5.4";

  outputs = [ "out" "dev" "devdoc" ];

  src = fetchgit {
    url = "https://git.launchpad.net/~unity-team/bamf";
    rev = version;
    sha256 = "1klvij1wyhdj5d8sr3b16pfixc1yk8ihglpjykg7zrr1f50jfgsz";
  };

  nativeBuildInputs = [
    (python3.withPackages (ps: with ps; [ lxml ])) # Tests
    autoconf
    automake
    dbus
    docbook_xsl
    gnome3.gnome-common
    gobject-introspection
    gtk-doc
    libtool
    pkgconfig
    vala
    which
    wrapGAppsHook
    xorgserver
  ];

  buildInputs = [
    glib
    libgtop
    libstartup_notification
    libwnck3
  ];

  patches = [
    # Port tests and checks to python3 lxml.
    ./gtester2xunit-python3.patch
  ];

  # Fix hard-coded path
  # https://bugs.launchpad.net/bamf/+bug/1780557
  postPatch = ''
    substituteInPlace data/Makefile.am \
      --replace '/usr/lib/systemd/user' '@prefix@/lib/systemd/user'
  '';

  configureFlags = [
    "--enable-gtk-doc"
    "--enable-headless-tests"
  ];

  # fix paths
  makeFlags = [
    "INTROSPECTION_GIRDIR=${placeholder "dev"}/share/gir-1.0/"
    "INTROSPECTION_TYPELIBDIR=${placeholder "out"}/lib/girepository-1.0"
  ];

  preConfigure = ''
    ./autogen.sh
  '';

  # TODO: Requires /etc/machine-id
  doCheck = false;

  # glib-2.62 deprecations
  NIX_CFLAGS_COMPILE = "-DGLIB_DISABLE_DEPRECATION_WARNINGS";

  meta = with stdenv.lib; {
    description = "Application matching framework";
    longDescription = ''
      Removes the headache of applications matching
      into a simple DBus daemon and c wrapper library.
    '';
    homepage = https://launchpad.net/bamf;
    license = licenses.lgpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ davidak ] ++ pantheon.maintainers;
  };
}
