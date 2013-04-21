{ kde, kdelibs, libjpeg, lcms1, jasper }:

kde {
  buildInputs = [ kdelibs libjpeg lcms1 jasper ];

  meta = {
    description = "Library for decoding RAW images";
    license = "GPLv2";
  };
}
