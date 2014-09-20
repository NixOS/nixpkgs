{ stdenv, kde, kdelibs }:

kde {
  buildInputs = [ kdelibs ];

  meta = {
    description = "Interface library to kipi-plugins";
    license = stdenv.lib.licenses.gpl2;
  };
}
