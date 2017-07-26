{ stdenv, fetchurl, python, buildPythonPackage, pkgconfig, glib }:

buildPythonPackage rec {
  name = "pygobject-${version}";
  version = "2.28.6";
  format = "other";

  src = fetchurl {
    url = "mirror://gnome/sources/pygobject/2.28/${name}.tar.xz";
    sha256 = "1f5dfxjnil2glfwxnqr14d2cjfbkghsbsn8n04js2c2icr7iv2pv";
  };

  outputs = [ "out" "devdoc" ];

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

    # Prevent wrapping of codegen files as these are meant to be
    # executed by the python program
    chmod a-x $out/share/pygobject/*/codegen/*.py
  '';

  meta = {
    homepage = http://live.gnome.org/PyGObject;
    description = "Python bindings for Glib";
    platforms = stdenv.lib.platforms.unix;
  };
}
