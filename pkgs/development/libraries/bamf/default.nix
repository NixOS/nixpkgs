{ lib, stdenv
, pantheon
, autoconf
, automake
, libtool
, gnome
, which
, fetchgit
, libgtop
, libwnck
, glib
, vala
, pkg-config
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
  version = "0.5.5";

  outputs = [ "out" "dev" "devdoc" ];

  src = fetchgit {
    url = "https://git.launchpad.net/~unity-team/bamf";
    rev = "${version}+21.10.20210710-0ubuntu1";
    sha256 = "0iwz5z5cz9r56pmfjvjd2kcjlk416dw6g38svs33ynssjgsqbdm0";
  };

  nativeBuildInputs = [
    (python3.withPackages (ps: with ps; [ lxml ])) # Tests
    autoconf
    automake
    dbus
    docbook_xsl
    gnome.gnome-common
    gobject-introspection
    gtk-doc
    libtool
    pkg-config
    vala
    which
    wrapGAppsHook
    xorgserver
  ];

  buildInputs = [
    glib
    libgtop
    libstartup_notification
    libwnck
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

  meta = with lib; {
    description = "Application matching framework";
    longDescription = ''
      Removes the headache of applications matching
      into a simple DBus daemon and c wrapper library.
    '';
    homepage = "https://launchpad.net/bamf";
    license = licenses.lgpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ davidak ] ++ teams.pantheon.members;
  };
}
