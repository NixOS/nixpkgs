{ stdenv, fetchurl, python, pkgconfig, gtk, pygobject, pycairo
, buildPythonPackage, libglade ? null, isPy3k }:

buildPythonPackage rec {
  name = "pygtk-2.24.0";
  
  disabled = isPy3k;

  src = fetchurl {
    url = "mirror://gnome/sources/pygtk/2.24/${name}.tar.bz2";
    sha256 = "04k942gn8vl95kwf0qskkv6npclfm31d78ljkrkgyqxxcni1w76d";
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
    ln -s ${pygobject}/lib/${python.libPrefix}/site-packages/pygobject-${pygobject.version}.pth \
                  $out/lib/${python.libPrefix}/site-packages/${name}.pth
  '';
}
