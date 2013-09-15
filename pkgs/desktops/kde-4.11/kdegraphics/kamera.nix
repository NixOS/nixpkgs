{ kde, kdelibs, libgphoto2 }:

kde {
  buildInputs = [ kdelibs libgphoto2 ];

  meta = {
    description = "KDE camera interface library";
    license = "GPLv2";
  };
}
