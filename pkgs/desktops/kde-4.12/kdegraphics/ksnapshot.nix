{ kde, kdelibs, libkipi, stdenv }:

kde {
  buildInputs = [ kdelibs libkipi ];

  meta = {
    description = "KDE screenshot utility";
    license = stdenv.lib.licenses.gpl2;
  };
}
