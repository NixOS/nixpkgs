{ stdenv
, buildPythonPackage
, fetchurl
, pkgs
, pygtk
}:

buildPythonPackage rec {
  pname = "pywebkitgtk";
  version = "1.1.8";
  format = "other";

  src = fetchurl {
    url = "http://pywebkitgtk.googlecode.com/files/${pname}-${version}.tar.bz2";
    sha256 = "1svlwyl61rvbqbcbalkg6pbf38yjyv7qkq9sx4x35yk69lscaac2";
  };

  nativeBuildInputs = [ pkgs.pkgconfig ];
  buildInputs = [ pygtk pkgs.gtk2 pkgs.libxml2 pkgs.libxslt pkgs.libsoup pkgs.webkitgtk24x-gtk2 pkgs.icu ];

  meta = with stdenv.lib; {
    homepage = "https://code.google.com/p/pywebkitgtk/";
    description = "Python bindings for the WebKit GTK+ port";
    license = licenses.lgpl2Plus;
  };

}
