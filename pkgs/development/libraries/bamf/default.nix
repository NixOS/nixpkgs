{ stdenv
, lib
, autoreconfHook
, gitUpdater
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
  version = "0.5.6";

  outputs = [ "out" "dev" "devdoc" ];

  src = fetchgit {
    url = "https://git.launchpad.net/~unity-team/bamf";
    rev = version;
    sha256 = "7U+2GcuDjPU8quZjkd8bLADGlG++tl6wSo0mUQkjAXQ=";
  };

  nativeBuildInputs = [
    (python3.withPackages (ps: with ps; [ lxml ])) # Tests
    autoreconfHook
    dbus
    docbook_xsl
    gnome.gnome-common
    gobject-introspection
    gtk-doc
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

  # Fix paths
  makeFlags = [
    "INTROSPECTION_GIRDIR=${placeholder "dev"}/share/gir-1.0/"
    "INTROSPECTION_TYPELIBDIR=${placeholder "out"}/lib/girepository-1.0"
  ];

  # TODO: Requires /etc/machine-id
  doCheck = false;

  # Ignore deprecation errors
  NIX_CFLAGS_COMPILE = "-DGLIB_DISABLE_DEPRECATION_WARNINGS";

  passthru.updateScript = gitUpdater {
    inherit pname version;
    ignoredVersions = ".ubuntu.*";
  };

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
