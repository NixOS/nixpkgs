{ stdenv
, fetchurl
, pkgconfig
, udev
, glib
, gobject-introspection
, gnome3
}:

stdenv.mkDerivation rec {
  pname = "libgudev";
  version = "234";

  outputs = [ "out" "dev" ];

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "0drf39qhsdz35kwb18hnfj2ig4yfxhfks66m783zlhnvy2narbhv";
  };

  nativeBuildInputs = [ pkgconfig gobject-introspection ];
  buildInputs = [ udev glib ];

  # There's a dependency cycle with umockdev and the tests fail to LD_PRELOAD anyway.
  configureFlags = [ "--disable-umockdev" ];

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
      versionPolicy = "none";
    };
  };

  meta = with stdenv.lib; {
    description = "A library that provides GObject bindings for libudev";
    homepage = "https://wiki.gnome.org/Projects/libgudev";
    maintainers = [ maintainers.eelco ] ++ teams.gnome.members;
    platforms = platforms.linux;
    license = licenses.lgpl2Plus;
  };
}
