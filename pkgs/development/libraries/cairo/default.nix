{ postscriptSupport ? true
, pdfSupport ? true
, pngSupport ? true
, stdenv, fetchurl, pkgconfig, x11, fontconfig, freetype
, zlib, libpng
}:

assert postscriptSupport -> zlib != null;
assert pngSupport -> libpng != null;

stdenv.mkDerivation {
  name = "cairo-1.2.4";
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/cairo-1.2.4.tar.gz;
    sha1 = "5520b771c8b85acea78fa56fc4c39b4dca6bcc7c";
  };
  buildInputs = [
    pkgconfig x11 fontconfig freetype
    (if pngSupport then libpng else null)
  ];
  propagatedBuildInputs = [
    (if postscriptSupport then zlib else null)
    (if pngSupport then libpng else null)
  ];
  configureFlags =
    (if pdfSupport then ["--enable-pdf"] else []);
}
