{ stdenv
, fetchgit
, fetchpatch
, pkgconfig
, glib
, icu
, gobject-introspection
, dbus-glib
, vala
, python3
, autoreconfHook
}:

stdenv.mkDerivation rec {
  pname = "dee";
  version = "unstable-2017-06-16";

  outputs = [ "out" "dev" "py" ];

  src = fetchgit {
    url = "https://git.launchpad.net/ubuntu/+source/dee";
    rev = "import/1.2.7+17.10.20170616-4ubuntu3";
    sha256 = "09blrdj7229vscp4mkg0fabmcvc6jdpamvblrq86rbky7j2nnwlk";
  };

  patches = [
    "${src}/debian/patches/gtkdocize.patch"
    "${src}/debian/patches/strict-prototype.patch"
    "${src}/debian/patches/vapi-skip-properties.patch"

    # Fixes glib 2.62 deprecations
    (fetchpatch {
      name = "dee-1.2.7-deprecated-g_type_class_add_private.patch";
      url = "https://src.fedoraproject.org/rpms/dee/raw/1a9a4ce3377074fabfca653ffe0287cd73aef82f/f/dee-1.2.7-deprecated-g_type_class_add_private.patch";
      sha256 = "13nyprq7bb7lnzkcb7frcpzidbl836ycn5bvmwa2k0nhmj6ycbx5";
    })
  ];

  nativeBuildInputs = [
    pkgconfig
    vala
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
    "--with-pygi-overrides-dir=${placeholder "py"}/${python3.sitePackages}/gi/overrides"
  ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "A library that uses DBus to provide objects allowing you to create Model-View-Controller type programs across DBus";
    homepage = "https://launchpad.net/dee";
    license = licenses.lgpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ abbradar worldofpeace ];
  };
}
