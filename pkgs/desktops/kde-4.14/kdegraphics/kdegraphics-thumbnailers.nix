{ stdenv, kde, kdelibs, libkexiv2, libkdcraw, pkgconfig }:

kde {

  buildInputs = [ kdelibs libkexiv2 libkdcraw ];

  nativeBuildInputs = [ pkgconfig ];

  meta = {
    description = "Thumbnailers for various graphics file formats";
    license = stdenv.lib.licenses.gpl2;
  };
}
