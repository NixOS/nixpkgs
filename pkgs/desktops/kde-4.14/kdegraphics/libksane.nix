{ stdenv, kde, kdelibs, sane-backends }:

kde {
  buildInputs = [ kdelibs sane-backends ];

  meta = {
    description = "An image scanning library that provides a QWidget that contains all the logic needed to interface a sacanner";
    license = stdenv.lib.licenses.gpl2;
  };
}
