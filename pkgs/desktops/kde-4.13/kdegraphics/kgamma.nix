{ kde, kdelibs, libXxf86vm }:

kde {
  buildInputs = [ kdelibs libXxf86vm ];

  meta = {
    description = "KDE monitor calibration tool";
    license = "GPLv2";
  };
}
