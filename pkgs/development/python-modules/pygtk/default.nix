{ stdenv, fetchurl, fetchpatch, python, pkgconfig, gtk2, pygobject2, pycairo, pango
, buildPythonPackage, libglade ? null, isPy3k }:

buildPythonPackage rec {
  pname = "pygtk";
  version = "2.24.0";

  disabled = isPy3k;

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.bz2";
    sha256 = "04k942gn8vl95kwf0qskkv6npclfm31d78ljkrkgyqxxcni1w76d";
  };

  patches = [
    # https://bugzilla.gnome.org/show_bug.cgi?id=660216 - fixes some memory leaks
    (fetchpatch {
      url = "https://gitlab.gnome.org/Archive/pygtk/commit/eca72baa5616fbe4dbebea43c7e5940847dc5ab8.diff";
      sha256 = "031px4w5cshcx1sns430sdbr2i007b9zyb2carb3z65nzr77dpdd";
    })
    (fetchpatch {
      url = "https://gitlab.gnome.org/Archive/pygtk/commit/4aaa48eb80c6802aec6d03e5695d2a0ff20e0fc2.patch";
      sha256 = "0z8cg7nr3qki8gg8alasdzzyxcihfjlxn518glq5ajglk3q5pzsn";
    })
  ];

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [
    pango
  ] ++ stdenv.lib.optional (libglade != null) libglade;

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
                  $out/lib/${python.libPrefix}/site-packages/${pname}-${version}.pth
  '';

  meta = with stdenv.lib; {
    description = "GTK 2 Python bindings";
    homepage = "https://gitlab.gnome.org/Archive/pygtk";
    platforms = platforms.all;
    license = with licenses; [ lgpl21Plus ];
  };
}
