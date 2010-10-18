{ stdenv, fetchurl, makeWrapper, python, pkgconfig, glib, gtk, pygobject, pycairo
, libglade ? null }:

stdenv.mkDerivation rec {
  name = "pygtk-2.22.0";

  src = fetchurl {
    url = "http://ftp.gnome.org/pub/GNOME/sources/pygtk/2.22/${name}.tar.bz2";
    sha256 = "4acf0ef2bde8574913c40ee4a43d9c4f43bb77b577b67147271b534501a54cc8";
  };

  buildInputs =
    [ makeWrapper python pkgconfig glib gtk ]
    ++ stdenv.lib.optional (libglade != null) libglade;

  propagatedBuildInputs = [ pygobject pycairo ];

  postInstall = ''
    rm $out/bin/pygtk-codegen-2.0
    ln -s ${pygobject}/bin/pygobject-codegen-2.0  $out/bin/pygtk-codegen-2.0

    # All python code is installed into a "gtk-2.0" sub-directory. That
    # sub-directory may be useful on systems which share several library
    # versions in the same prefix, i.e. /usr/local, but on Nix that directory
    # is useless. Furthermore, its existence makes it very hard to guess a
    # proper $PYTHONPATH that allows "import gtk" to succeed.
    cd $(toPythonPath $out)/gtk-2.0
    for n in *; do
      ln -s "gtk-2.0/$n" "../$n"
    done

    wrapProgram $out/bin/pygtk-demo --prefix PYTHONPATH ":" \
        $(toPythonPath "${pygobject} ${pycairo} $out")
  '';
}
