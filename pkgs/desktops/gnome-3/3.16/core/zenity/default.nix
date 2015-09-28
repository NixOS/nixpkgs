{ stdenv, fetchurl, pkgconfig, cairo, libxml2, libxslt, gnome3, pango
, gnome_doc_utils, intltool, libX11, which, itstool }:

stdenv.mkDerivation rec {

  versionMajor = "3.16";
  versionMinor = "3";

  name = "zenity-${versionMajor}.${versionMinor}";

  src = fetchurl {
    url = "mirror://gnome/sources/zenity/${versionMajor}/${name}.tar.xz";
    sha256 = "1fhyzcmhrzqi10ks1gy8cxyqnbdfsnmqw3bkixnzrcf5zcb81qkz";
  };

  preBuild = ''
    mkdir -p $out/include
  '';

  buildInputs = [ gnome3.gtk libxml2 libxslt libX11 itstool ];

  nativeBuildInputs = [ pkgconfig intltool gnome_doc_utils which ];

  meta = with stdenv.lib; {
    platforms = platforms.linux;
    maintainers = gnome3.maintainers;
  };
}
