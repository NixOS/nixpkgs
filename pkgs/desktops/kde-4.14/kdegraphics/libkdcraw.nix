{ stdenv, kde, kdelibs, pkgconfig, libraw, lcms2 }:

kde {

  buildInputs = [ kdelibs libraw lcms2 ];

  meta = {
    description = "Library for decoding RAW images";
    license = stdenv.lib.licenses.gpl2;
  };
}
