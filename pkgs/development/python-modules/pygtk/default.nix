{ stdenv, fetchurl, python, pkgconfig, gtk, pygobject, pycairo
, buildPythonPackage, libglade ? null }:

buildPythonPackage rec {
  name = "pygtk-2.22.0";

  src = fetchurl {
    url = "mirror://gnome/sources/pygtk/2.22/${name}.tar.bz2";
    sha256 = "4acf0ef2bde8574913c40ee4a43d9c4f43bb77b577b67147271b534501a54cc8";
  };

  buildInputs = [ pkgconfig ]
    ++ stdenv.lib.optional (libglade != null) libglade;

  propagatedBuildInputs = [ gtk pygobject pycairo ];

  configurePhase = "configurePhase";

  buildPhase = "buildPhase";

  installPhase = "installPhase";

  checkPhase = stdenv.lib.optionalString (libglade == null)
    ''
      sed -i -e "s/glade = importModule('gtk.glade', buildDir)//" \
             tests/common.py
      sed -i -e "s/, glade$//" \
             -e "s/.*testGlade.*//" \
             -e "s/.*(glade.*//" \
             tests/test_api.py
    '' + ''
      sed -i -e "s/sys.path.insert(0, os.path.join(buildDir, 'gtk'))//" \
             -e "s/sys.path.insert(0, buildDir)//" \
             tests/common.py
      make check
    '';
  # XXX: TypeError: Unsupported type: <class 'gtk._gtk.WindowType'>
  # The check phase was not executed in the previous
  # non-buildPythonPackage setup - not sure why not.
  doCheck = false;

  postInstall = ''
    rm $out/bin/pygtk-codegen-2.0
    ln -s ${pygobject}/bin/pygobject-codegen-2.0  $out/bin/pygtk-codegen-2.0
    ln -s ${pygobject}/lib/${python.libPrefix}/site-packages/${pygobject.name}.pth \
                  $out/lib/${python.libPrefix}/site-packages/${name}.pth
  '';
}
