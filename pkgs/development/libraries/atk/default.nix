{ stdenv, fetchurl, pkgconfig, perl, glib, libintlOrEmpty, gobjectIntrospection, gnome3 }:

let
  pname = "atk";
  version = "2.28.1";
in
stdenv.mkDerivation rec {
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${gnome3.versionBranch version}/${name}.tar.xz";
    sha256 = "1z7laf6qwv5zsqcnj222dm5f43c6f3liil0cgx4s4s62xjk1wfnd";
  };

  enableParallelBuilding = true;

  outputs = [ "out" "dev" ];

  buildInputs = libintlOrEmpty;

  nativeBuildInputs = [ pkgconfig perl gobjectIntrospection ];

  propagatedBuildInputs = [
    # Required by atk.pc
    glib
  ];

  doCheck = true;

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
    };
  };

  meta = {
    description = "Accessibility toolkit";

    longDescription = ''
      ATK is the Accessibility Toolkit.  It provides a set of generic
      interfaces allowing accessibility technologies such as screen
      readers to interact with a graphical user interface.  Using the
      ATK interfaces, accessibility tools have full access to view and
      control running applications.
    '';

    homepage = http://library.gnome.org/devel/atk/;

    license = stdenv.lib.licenses.lgpl2Plus;

    maintainers = with stdenv.lib.maintainers; [ raskin ];
    platforms = stdenv.lib.platforms.linux ++ stdenv.lib.platforms.darwin;
  };

}
