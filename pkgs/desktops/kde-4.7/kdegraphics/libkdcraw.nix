{ kde, kdelibs, libjpeg, lcms1 }:

kde {
  buildInputs = [ kdelibs libjpeg lcms1 ];

  meta = {
    description = "Library for decoding RAW images";
    license = "GPLv2";
  };
}
