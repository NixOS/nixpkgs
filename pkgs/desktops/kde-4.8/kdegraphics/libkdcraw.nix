{ kde, kdelibs }:

kde {
  buildInputs = [ kdelibs ];

  meta = {
    description = "Library for decoding RAW images";
    license = "GPLv2";
  };
}
