{ stdenv, kde, kdelibs, qimageblitz }:

kde {
  buildInputs = [ kdelibs qimageblitz ];

  meta = {
    description = "KDE paint program";
    license = stdenv.lib.licenses.gpl2;
  };
}
