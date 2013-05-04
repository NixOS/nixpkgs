{ kde, kdelibs, libkexiv2, libkdcraw }:

kde {
  buildInputs = [ kdelibs libkexiv2 libkdcraw ];

  meta = {
    description = "Thumbnailers for various graphics file formats";
    license = "GPLv2";
  };
}
