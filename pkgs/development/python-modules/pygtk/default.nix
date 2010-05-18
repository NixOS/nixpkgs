{stdenv, fetchurl, python, pkgconfig, glib, gtk, pygobject, pycairo
  , libglade ? null}:

stdenv.mkDerivation {
  name = "pygtk-2.16.0";

  src = fetchurl {
    url = http://ftp.gnome.org/pub/GNOME/sources/pygtk/2.16/pygtk-2.16.0.tar.bz2;
    sha256 = "1a24fkxslir8zb800hs4ix9iyvgqsy5c6hdfirrh2yi1mw0mxbkz";
  };
  
  buildInputs = [python pkgconfig glib gtk]
    ++ (if libglade != null then [libglade] else [])
  ;

  propagatedBuildInputs = [pygobject pycairo];

  postInstall = ''
    rm $out/bin/pygtk-codegen-2.0
    ln -s ${pygobject}/bin/pygobject-codegen-2.0  $out/bin/pygtk-codegen-2.0
  '';
}
