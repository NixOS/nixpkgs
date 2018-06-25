{ stdenv, fetchurl, buildPythonPackage, pkgconfig, gtk2, pygtk, gtkglext, pygobject2
, libglade ? null, libGLU, xorg, isPy3k }:

buildPythonPackage rec {
  pname = "pygtkglext";
  version = "1.1.0";
  format = "other";

  disabled = isPy3k;

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/1.1/${pname}-${version}.tar.gz";
    sha256 = "18vq07f65rgxdnplc59sh3mc55800ir6cshcbv8ffvmzc16c04lp";
  };

  nativeBuildInputs = [ pkgconfig ];
  propagatedBuildInputs = [
    pygtk pygobject2 gtk2 gtkglext
    libGLU xorg.libXmu
  ];
  configureFlags = "--disable-gtkglext-test";

  meta = {
    description = "Python GTK GL extension bindings";
    homepage = https://projects-old.gnome.org/gtkglext/index.html ;
    license = stdenv.lib.licenses.gpl2;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.numinit ];
  };
}
