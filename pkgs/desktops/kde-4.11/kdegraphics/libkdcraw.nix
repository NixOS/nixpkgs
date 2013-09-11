{ kde, kdelibs, libjpeg_original, lcms1, jasper, pkgconfig }:

kde {

  buildInputs = [ kdelibs libjpeg_original lcms1 jasper ];

  nativeBuildInputs = [ pkgconfig ];

  meta = {
    description = "Library for decoding RAW images";
    license = "GPLv2";
  };
}
