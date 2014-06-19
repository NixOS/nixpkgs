{ kde, kdelibs, libkexiv2, libkdcraw, pkgconfig, stdenv }:

kde {

  buildInputs = [ kdelibs libkexiv2 libkdcraw ];

  nativeBuildInputs = [ pkgconfig ];

  meta = {
    description = "Thumbnailers for various graphics file formats";
    license = stdenv.lib.licenses.gpl2;
  };
}
