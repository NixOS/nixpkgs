{ stdenv, fetchurl, python, pkgconfig, gtk2, pygobject2, pycairo
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

  propagatedBuildInputs = [ gtk2 pygobject2 pycairo ];

  configurePhase = "configurePhase";

  buildPhase = "buildPhase";

  NIX_CFLAGS_COMPILE = stdenv.lib.optionalString stdenv.isDarwin "-ObjC";

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
    ln -s ${pygobject2}/bin/pygobject-codegen-2.0  $out/bin/pygtk-codegen-2.0
    ln -s ${pygobject2}/lib/${python.libPrefix}/site-packages/pygobject-${pygobject2.version}.pth \
                  $out/lib/${python.libPrefix}/site-packages/${name}.pth
  '';
}
