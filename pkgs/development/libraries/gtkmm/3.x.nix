{ lib, stdenv, fetchurl, pkg-config, meson, ninja, python3, gtk3, glibmm, cairomm, pangomm, atkmm, libepoxy, gnome, glib, gdk-pixbuf }:

stdenv.mkDerivation rec {
  pname = "gtkmm";
  version = "3.24.7";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "HXo1r5xc7MrLJE7jwt65skVyDYUQrFx+b0tvmUfmeJw=";
  };

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [
    pkg-config
    meson
    ninja
    python3
    glib
    gdk-pixbuf # for gdk-pixbuf-pixdata
  ];
  buildInputs = [ libepoxy ];

  propagatedBuildInputs = [ glibmm gtk3 atkmm cairomm pangomm ];

  # https://bugzilla.gnome.org/show_bug.cgi?id=764521
  doCheck = false;

  passthru = {
    updateScript = gnome.updateScript {
      packageName = pname;
      attrPath = "${pname}3";
      versionPolicy = "odd-unstable";
      freeze = true;
    };
  };

  meta = with lib; {
    description = "C++ interface to the GTK graphical user interface library";

    longDescription = ''
      gtkmm is the official C++ interface for the popular GUI library
      GTK.  Highlights include typesafe callbacks, and a
      comprehensive set of widgets that are easily extensible via
      inheritance.  You can create user interfaces either in code or
      with the Glade User Interface designer, using libglademm.
      There's extensive documentation, including API reference and a
      tutorial.
    '';

    homepage = "https://gtkmm.org/";

    license = licenses.lgpl2Plus;

    maintainers = with maintainers; [ raskin ];
    platforms = platforms.unix;
  };
}
