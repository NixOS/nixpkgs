{ stdenv, fetchurl, python, mkPythonDerivation, pkgconfig, glib }:

mkPythonDerivation rec {
  name = "pygobject-2.28.6";
  
  src = fetchurl {
    url = "mirror://gnome/sources/pygobject/2.28/${name}.tar.xz";
    sha256 = "1f5dfxjnil2glfwxnqr14d2cjfbkghsbsn8n04js2c2icr7iv2pv";
  };

  outputs = [ "out" "docdev" ];

  patches = [
    # Fix warning spam
    ./pygobject-2.28.6-set_qdata.patch
    ./pygobject-2.28.6-gio-types-2.32.patch
  ];

  configureFlags = "--disable-introspection";

  buildInputs = [ pkgconfig glib ];

  # in a "normal" setup, pygobject and pygtk are installed into the
  # same site-packages: we need a pth file for both. pygtk.py would be
  # used to select a specific version, in our setup it should have no
  # effect, but we leave it in case somebody expects and calls it.
  postInstall = ''
    mv $out/lib/${python.libPrefix}/site-packages/{pygtk.pth,${name}.pth}
  '';

  meta = {
    homepage = http://live.gnome.org/PyGObject;
    description = "Python bindings for Glib";
    platforms = stdenv.lib.platforms.unix;
  };
}
