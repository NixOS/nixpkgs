{ stdenv
, fetchgit
, pkgconfig
, glib
, vala
, dee
, gobject-introspection
, libdbusmenu
, gtk3
, intltool
, python3
, autoreconfHook
}:

stdenv.mkDerivation {
  pname = "libunity";
  version = "unstable-2019-03-19";

  outputs = [ "out" "dev" "py" ];

  src = fetchgit {
    url = "https://git.launchpad.net/ubuntu/+source/libunity";
    rev = "import/7.1.4+19.04.20190319-0ubuntu1";
    sha256 = "15b49v88v74q20a5c0lq867qnlz7fx20xifl6j8ha359r0zkfwzj";
  };

  nativeBuildInputs = [
    autoreconfHook
    gobject-introspection
    intltool
    pkgconfig
    python3
    vala
  ];

  buildInputs = [
    glib
    gtk3
  ];

  propagatedBuildInputs = [
    dee
    libdbusmenu
  ];

  preConfigure = ''
    intltoolize
  '';

  configureFlags = [
    "--with-pygi-overrides-dir=${placeholder "py"}/${python3.sitePackages}/gi/overrides"
  ];

  meta = with stdenv.lib; {
    description = "A library for instrumenting and integrating with all aspects of the Unity shell";
    homepage = https://launchpad.net/libunity;
    license = licenses.lgpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ worldofpeace ];
  };
}
