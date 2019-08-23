{ stdenv
, fetchgit
, pkgconfig
, glib
, icu
, gobject-introspection
, dbus-glib
, vala_0_40
, python3
, autoreconfHook
}:

stdenv.mkDerivation rec {
  pname = "dee";
  version = "unstable-2017-06-16";

  outputs = [ "out" "dev" "py" ];

  src = fetchgit {
    url = "https://git.launchpad.net/ubuntu/+source/dee";
    rev = "import/1.2.7+17.10.20170616-4ubuntu1";
    sha256 = "0q3d9d6ahcyibp6x23g1wvjfcppjh9v614s328yjmx47216z7394";
  };

  patches = [
    "${src}/debian/patches/gtkdocize.patch"
    "${src}/debian/patches/strict-prototype.patch"
    "${src}/debian/patches/icu-pkg-config.patch"
  ];

  nativeBuildInputs = [
    pkgconfig
    # https://gitlab.gnome.org/GNOME/vala/issues/803
    vala_0_40
    autoreconfHook
    gobject-introspection
    python3
  ];

  buildInputs = [
    glib
    icu
    dbus-glib
  ];

  configureFlags = [
    "--disable-gtk-doc"
    "--with-pygi-overrides-dir=${placeholder ''py''}/${python3.sitePackages}/gi/overrides"
  ];

  meta = with stdenv.lib; {
    description = "A library that uses DBus to provide objects allowing you to create Model-View-Controller type programs across DBus";
    homepage = https://launchpad.net/dee;
    license = licenses.lgpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ abbradar worldofpeace ];
  };
}
