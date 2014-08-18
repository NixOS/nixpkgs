{ kde, kdelibs, stdenv }:

kde {
  buildInputs = [ kdelibs ];

  meta = {
    description = "KDE screen ruler";
    license = stdenv.lib.licenses.gpl2;
  };
}
