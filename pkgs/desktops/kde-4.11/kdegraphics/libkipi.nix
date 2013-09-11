{ kde, kdelibs }:

kde {
  buildInputs = [ kdelibs ];

  meta = {
    description = "Interface library to kipi-plugins";
    license = "GPLv2";
  };
}
