{ kde, kdelibs, pkgconfig, libraw, lcms2, stdenv }:

kde {

  buildInputs = [ kdelibs libraw lcms2 ];

  nativeBuildInputs = [ pkgconfig ];

  meta = {
    description = "Library for decoding RAW images";
    license = stdenv.lib.licenses.gpl2;
  };
}
